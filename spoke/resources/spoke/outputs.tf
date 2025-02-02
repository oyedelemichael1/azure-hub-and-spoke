output "spoke_vnet_cidr" {
  description = "CIDR block of the Spoke VNet"
  value       = azurerm_virtual_network.spoke.address_space
}

output "resource_group_name" {
  description = "The name of the Azure Resource Group"
  value       = azurerm_resource_group.hub_spoke_rg.name
}

output "resource_group_location" {
  description = "The location of the Azure Resource Group"
  value       = azurerm_resource_group.hub_spoke_rg.location
}