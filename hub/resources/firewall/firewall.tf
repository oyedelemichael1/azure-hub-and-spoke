# firewall network rule
resource "azurerm_firewall_network_rule_collection" "network-collection" {
  provider            = azurerm.hub
  count               = var.firewall_rule_type == "network" ? 1 : 0
  name                = var.collection_name
  azure_firewall_name = var.azure_firewall_name
  resource_group_name = var.resource_group_name
  priority            = var.priority
  action              = var.firewall_action

  dynamic "rule" {
    for_each = var.rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      protocols             = rule.value.protocols
    }
  }
}

#dnat firewall rule
resource "azurerm_firewall_nat_rule_collection" "nat_collection" {
  provider            = azurerm.hub
  count               = var.firewall_rule_type == "nat" ? 1 : 0
  name                = var.collection_name
  azure_firewall_name = var.azure_firewall_name
  resource_group_name = var.resource_group_name
  priority            = var.priority
  action              = "Dnat"


  dynamic "rule" {
    for_each = var.rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
      protocols             = rule.value.protocols
    }
  }
}

#application rule
resource "azurerm_firewall_application_rule_collection" "example" {
  provider            = azurerm.hub
  count               = var.firewall_rule_type == "app" ? 1 : 0
  name                = var.collection_name
  azure_firewall_name = var.azure_firewall_name
  resource_group_name = var.resource_group_name
  priority            = var.priority
  action              = var.firewall_action

  dynamic "rule" {
    for_each = var.rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      target_fqdns     = rule.value.target_fqdns
      dynamic "protocol" {
        for_each = rule.value["app_rule_protocols"]
        content {
          port = protocol.value["port"]
          type = protocol.value["type"]
        }
      }
    }
  }

}