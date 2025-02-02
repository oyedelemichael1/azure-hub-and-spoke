data "terraform_remote_state" "hub" {
  backend = "azurerm"

  config = {
    container_name       = "<storage container name>"
    storage_account_name = "<storage account name>"
    key                  = "hub.terraform.tfstateenv:hub"
    resource_group_name  = "<storage account resource group name>"
  }
}

module "spoke" {
  source = "./resources/spoke"

  resource_group_name      = "${terraform.workspace}-rg"
  resource_group_location  = var.resource_group_location
  hub_vnet_name            = data.terraform_remote_state.hub.outputs.hub_vnet_name
  hub_vnet_id              = data.terraform_remote_state.hub.outputs.hub_vnet_id
  firewall_private_ip      = data.terraform_remote_state.hub.outputs.firewall_private_ip
  hub_resource_group       = data.terraform_remote_state.hub.outputs.resource_group_name
  spoke_vnet_name          = "${terraform.workspace}-vnet"
  spoke_vnet_address_space = var.spoke_vnet_address_space
  spoke_vnet_subnets       = var.spoke_vnet_subnets

  providers = {
    azurerm.spoke = azurerm.spoke
    azurerm.hub   = azurerm.hub
  }
}
