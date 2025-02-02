variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string

}

variable "resource_group_location" {
  description = "The location of the Azure resource group"
  type        = string
}

variable "spoke_vnet_subnets" {
  description = "A map of subnets where key is the name and value is the CIDR"
  type        = map(string)
  default = {
    "default" = "10.0.0.0/24"
  }
}

variable "spoke_vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "hub-vnet"
}

variable "spoke_vnet_address_space" {
  description = "The address space of the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "hub_vnet_name" {
  description = "The name of the hub virtual network"
  type        = string
}
variable "hub_vnet_id" {
  description = "The ID of the hub virtual network"
  type        = string
}
variable "hub_resource_group" {
  description = "The resource group of the hub virtual network"
  type        = string
}

variable "firewall_private_ip" {
  description = "The private IP of the firewall "
  type        = string
}