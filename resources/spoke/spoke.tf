resource "azurerm_resource_group" "hub_spoke_rg" {
  provider            = azurerm.spoke
  name     = var.resource_group_name
  location = var.resource_group_location
}

#spoke1 vnet
resource "azurerm_virtual_network" "spoke" {
  provider            = azurerm.spoke
  name                = var.spoke_vnet_name
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  address_space       = [var.spoke_vnet_address_space]

}

#spoke subnet
resource "azurerm_subnet" "spoke_subnet" {
  provider            = azurerm.spoke
  for_each            = var.spoke_vnet_subnets
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  name               = each.key
  address_prefixes   = [each.value]

}

#route table to route all traffic through firewall
resource "azurerm_route_table" "rt" {
  provider            = azurerm.spoke
  name                          = "firewall-rt"
  location                      = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name           = azurerm_resource_group.hub_spoke_rg.name

  route {
    name                   = "firewall-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${var.firewall_private_ip}"
  }
}

# Associate firewall route table to each subnet
resource "azurerm_subnet_route_table_association" "spoke_rt_association" {
  provider            = azurerm.spoke
   for_each       = var.spoke_vnet_subnets
  subnet_id      = azurerm_subnet.spoke_subnet[each.key].id
  route_table_id = azurerm_route_table.rt.id
}


#peer hub to spoke
resource "azurerm_virtual_network_peering" "hub" {
  provider            = azurerm.hub
  name                      = "peer-${var.hub_vnet_name}-to-${var.spoke_vnet_name}"
  resource_group_name       = var.hub_resource_group
  virtual_network_name      = var.hub_vnet_name //hub vnet name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id
}

#peer spoke to hub
resource "azurerm_virtual_network_peering" "spoke" {
  provider            = azurerm.spoke
  name                      = "peer-${var.spoke_vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name       = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = var.hub_vnet_id //hub vnet id
}

