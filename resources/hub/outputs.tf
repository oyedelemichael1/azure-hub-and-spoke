output "firewall_public_ip" {
  value = azurerm_public_ip.firewall_public_ip.ip_address
  description = "The public IP address of the firewall"
}

output "firewall_private_ip" {
  value = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
  description = "The private IP address of the firewall"
}

output "firewall_route_table_id" {
  value = azurerm_route_table.rt.id
  description = "The ID of the firewall route table"
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
  description = "The name of the hub vnet"
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
  description = "The ID of the hub vnet"
}

output "firewall_name" {
  value = azurerm_firewall.hub_firewall.name
  description = "The name of the firewall device"
    
}

output "resource_group_name" {
  description = "The name of the Azure Resource Group"
  value       = azurerm_resource_group.hub_spoke_rg.name
}

output "resource_group_location" {
  description = "The location of the Azure Resource Group"
  value       = azurerm_resource_group.hub_spoke_rg.location
}
