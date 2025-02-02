variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
  default     = "hub-spoke-rg"
}

variable "resource_group_location" {
  description = "The location of the Azure resource group"
  type        = string
  default     = "West Europe"
}

variable "hub_subscription_id" {
  description = "The subscription od the hub"
  type        = string
}


variable "client_id" {
  description = "Azure Service Principal Client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Azure Service Principal Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "access_key" {
  description = "The azurerm terraform backend access key"
  type        = string
}