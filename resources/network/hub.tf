#hub network
resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  address_space       = [var.hub_vnet_address_space]
}

resource "azurerm_subnet" "hub_subnets" {
  for_each            = var.hub_vnet_subnets
  name                = each.key
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes    = [each.value]
}



#firewall subnet
resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_address_space]
}

#firewall device public IP
resource "azurerm_public_ip" "firewall_public_ip" {
  name                = "firewall-public-ip"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


#firewall
resource "azurerm_firewall" "hub_firewall" {
  name                = "firewall-device"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_public_ip.id
  }
}


#firewall network rule
# resource "azurerm_firewall_network_rule_collection" "network-collection" {
#   name                = "allow-spoke-to-spoke"
#   azure_firewall_name = azurerm_firewall.hub_firewall.name
#   resource_group_name = azurerm_resource_group.hub_spoke_rg.name
#   priority            = 100
#   action              = "Allow"

#   rule {
#         name = "allow spoke1 to spoke2"
#         source_addresses = ["10.1.0.0/16"]
#         destination_ports = ["22"]
#         destination_addresses = [ "10.2.0.0/16" ]
#         protocols = [ "TCP" ]
#   }

#    rule {
#         name = "allow spoke2 to spoke1"
#         source_addresses = ["10.2.0.0/16"]
#         destination_ports = ["22"]
#         destination_addresses = [ "10.1.0.0/16" ]
#         protocols = [ "TCP" ]
#     }
# }


# #firewall dnat rule
# resource "azurerm_firewall_nat_rule_collection" "nat_collection" {
#   name                = "allow-everyone-to-hub-vm"
#   azure_firewall_name = azurerm_firewall.hub_firewall.name
#   resource_group_name = azurerm_resource_group.hub_spoke_rg.name
#   priority            = 200
#   action              = "Dnat"

#   rule {
#     name = "allow access to hub VM"
#     source_addresses = ["0.0.0.0/0"]
#     destination_ports = ["22"]
#     destination_addresses = [azurerm_public_ip.firewall_public_ip.ip_address]
#     translated_port = 22
#     translated_address = "${azurerm_network_interface.hub_vm_nic.ip_configuration[0].private_ip_address}"
#     protocols = ["TCP"]
#   }
# }


#route table to route all traffic through firewall
resource "azurerm_route_table" "rt" {
  name                          = "firewall-rt"
  location                      = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name           = azurerm_resource_group.hub_spoke_rg.name

  route {
    name                   = "firewall-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address}"
  }
}

#associate firewall route table to hub default subnet
resource "azurerm_subnet_route_table_association" "hub_gateway_rt_hub_vnet_gateway_subnet" {
  for_each        = azurerm_subnet.hub_subnets
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.rt.id
  depends_on     = [azurerm_subnet.hub_subnets]
}

