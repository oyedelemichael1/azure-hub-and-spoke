
locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  network_subnets = flatten([
    for vnet, network in var.spoke_vnets : [
      for subnet_name, subnet in network.subnets : {
        network_name = vnet
        subnet_name  = subnet_name
        virtual_network_name  = azurerm_virtual_network.spoke[vnet].name
        cidr_block  = subnet.cidr_block
      }
    ]
  ])
}

#spoke1 vnet
resource "azurerm_virtual_network" "spoke" {
  for_each            = var.spoke_vnets
  name                = each.key
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  address_space       = [each.value.address_space]

}

resource "azurerm_subnet" "spoke_subnet" {
  for_each = tomap({
    for subnet in local.network_subnets : "${subnet.network_name}.${subnet.subnet_name}" => subnet
  })
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  virtual_network_name = each.value.network_name
  name               = each.value.subnet_name
  address_prefixes   = ["${each.value.cidr_block}"]

}

# Associate firewall route table to each subnet
resource "azurerm_subnet_route_table_association" "spoke_rt_association" {
   for_each       = azurerm_subnet.spoke_subnet
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.rt.id
}

