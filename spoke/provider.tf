terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "<storage account resource group name>"
    storage_account_name = "<storage account name>"
    container_name       = "<storage container name>"
    key                  = "spoke.terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}


provider "azurerm" {
  alias           = "hub"
  subscription_id = var.hub_subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

provider "azurerm" {
  alias           = "spoke"
  subscription_id = var.spoke_subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}
