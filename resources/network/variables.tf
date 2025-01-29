variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
  default =  "hub-spoke-rg"
}

variable "resource_group_location" {
  description = "The location of the Azure resource group"
  type        = string
  default = "West Europe"
}

variable "hub_vnet_subnets" {
  description = "A map of subnets where key is the name and value is the CIDR"
  type        = map(string)
  default     = {
    "default"       = "10.0.0.0/24"
  }
}

variable "hub_vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "hub-vnet"
}

variable "hub_vnet_address_space" {
  description = "The address space of the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "firewall_address_space" {
  description = "The address space of the firewall device"
  type        = string
  default     = "10.0.1.0/24"
}


variable "spoke_vnets" {
  description = "Map of spoke VNets, each containing a map of subnets (key=name, value=address prefix)"
  type = map(object({
    address_space = string
    subnets       = map(object({ cidr_block = string }))
  }))
}


