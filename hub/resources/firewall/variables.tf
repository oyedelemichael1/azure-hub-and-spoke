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
    destination_ports     = optional(list(string)) # Only used in NAT and network rules
    destination_addresses = optional(list(string)) # Only used in NAT and network rules
    protocols             = optional(list(string)) # Only used in NAT and network rules
    translated_address    = optional(string)       # Only used in NAT rules
    translated_port       = optional(string)       # Only used in NAT rules
    target_fqdns          = optional(list(string)) # Only used in Application rules
    app_rule_protocols = optional(list(object({    # Only used in Application rules
      port = number
      type = string
    })))
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
  default     = "Allow"
}

variable "firewall_rule_type" {
  description = "The firewall rule type, nat or network"
  type        = string
  default     = "network"
}

variable "azure_firewall_name" {
  description = "The firewall where the rule would be created"
  type        = string
}

