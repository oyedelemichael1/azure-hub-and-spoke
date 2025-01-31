variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
}

variable "resource_group_location" {
  description = "The location of the Azure resource group"
  type        = string
}


variable "rules" {
  type = list(object({
    name                  = string
    source_addresses      = list(string)
    destination_ports     = list(string)
    destination_addresses = list(string) 
    protocols             = list(string)
    translated_address    = optional(string)        # Only used in NAT rules
    translated_port       = optional(string)        # Only used in NAT rules
  }))
}


variable "priority" {
  description = "The rule priority, minimum of 100"
  type        = number
}

variable "collection_name" {
  description = "The name of the firewall collection"
  type        = string
}

variable "firewall_action" {
  description = "The firewall action, Allow or Deny"
  type        = string
  default = "Allow"
}

variable "firewall_rule_type" {
  description = "The firewall rule type, nat or network"
  type        = string
  default = "network"
}

variable "azure_firewall_name" {
  description = "The firewall where the rule would be created"
  type        = string
}

