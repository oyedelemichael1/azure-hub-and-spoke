resource "azurerm_resource_group" "hub_spoke_rg" {
  name     = "hub-spoke-rg"
  location = "West Europe"
}

data "azurerm_subscription" "current" {}

#network manager
resource "azurerm_network_manager" "hub_spoke_network_manager" {
  name                = "hub-spoke-network-manager"
  location            = azurerm_resource_group.hub_spoke_rg.location
  resource_group_name = azurerm_resource_group.hub_spoke_rg.name
  scope {
    subscription_ids = [data.azurerm_subscription.current.id]
  }
  scope_accesses = ["Connectivity", "SecurityAdmin"]
  description    = "hub and spoke network manager"
}


#network group
resource "azurerm_network_manager_network_group" "spoke_network_group" {
  name               = "spoke-network-group"
  network_manager_id = azurerm_network_manager.hub_spoke_network_manager.id
}

#group member 1
resource "azurerm_network_manager_static_member" "spoke1_nmsm" {
  name                      = "spoke1-nmsm"
  network_group_id          = azurerm_network_manager_network_group.spoke_network_group.id
  target_virtual_network_id = azurerm_virtual_network.spoke1.id
}

#group member 2
resource "azurerm_network_manager_static_member" "spoke2_nmsm" {
  name                      = "spoke2-nmsm"
  network_group_id          = azurerm_network_manager_network_group.spoke_network_group.id
  target_virtual_network_id = azurerm_virtual_network.spoke2.id
}

#connectivity configuration
resource "azurerm_network_manager_connectivity_configuration" "connectivity_config" {
  name                  = "connectivity-config"
  network_manager_id    = azurerm_network_manager.hub_spoke_network_manager.id
  connectivity_topology = "HubAndSpoke"
  applies_to_group {
    group_connectivity = "None" #"DirectlyConnected"
    network_group_id   = azurerm_network_manager_network_group.spoke_network_group.id
  }

  hub {
    resource_id   = azurerm_virtual_network.hub.id
    resource_type = "Microsoft.Network/virtualNetworks"
  }
}

#connectivity config deployment 
resource "azurerm_network_manager_deployment" "connectivity_deployment" {
  network_manager_id = azurerm_network_manager.hub_spoke_network_manager.id
  location           = "West Europe"
  scope_access       = "Connectivity"
  configuration_ids  = [azurerm_network_manager_connectivity_configuration.connectivity_config.id]
}
