resource "azurerm_resource_group" "hub_spoke_rg" {
  provider = azurerm.hub
  name     = var.resource_group_name
  location = var.resource_group_location
}

#hub network
resource "azurerm_virtual_network" "hub" {
  provider            = azurerm.hub
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  address_space       = [var.hub_vnet_address_space]
  depends_on          = [azurerm_resource_group.hub_spoke_rg]
}

#hub subnets
resource "azurerm_subnet" "hub_subnets" {
  provider             = azurerm.hub
  for_each             = var.hub_vnet_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [each.value]
  depends_on           = [azurerm_virtual_network.hub]
}



#firewall subnet
resource "azurerm_subnet" "firewall_subnet" {
  provider             = azurerm.hub
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_address_space]
  depends_on           = [azurerm_virtual_network.hub]
}

#firewall device public IP
resource "azurerm_public_ip" "firewall_public_ip" {
  provider            = azurerm.hub
  name                = "firewall-public-ip"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.hub_spoke_rg]
}


#firewall
resource "azurerm_firewall" "hub_firewall" {
  provider            = azurerm.hub
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



#route table to route all traffic through firewall
resource "azurerm_route_table" "rt" {
  provider            = azurerm.hub
  name                = "firewall-rt"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name

  route {
    name                   = "firewall-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
  }
}

#associate firewall route table to hub default subnet
resource "azurerm_subnet_route_table_association" "hub_gateway_rt_hub_vnet_gateway_subnet" {
  provider       = azurerm.hub
  for_each       = azurerm_subnet.hub_subnets
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.rt.id
  depends_on     = [azurerm_subnet.hub_subnets]
}

