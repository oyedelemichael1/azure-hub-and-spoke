# output "firewall_public_ip" {
#   value = azurerm_public_ip.firewall_public_ip.ip_address
#   description = "The public IP address of the firewall"
# }

# output "hub_vm_private_ip" {
#   value = azurerm_network_interface.hub_vm_nic.ip_configuration[0].private_ip_address
#   description = "The private IP address of the hub vm"
# }

# output "spoke1_vm_private_ip" {
#   value = azurerm_network_interface.spoke1_vm_nic.ip_configuration[0].private_ip_address
#   description = "The private IP address of the spoke1"
# }

# output "spoke2_vm_private_ip" {
#   value = azurerm_network_interface.spoke2_vm_nic.ip_configuration[0].private_ip_address
#   description = "The private IP address of the spoke2"
# }