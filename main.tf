module "hub" {
  source = "./resources/hub"

  resource_group_name     = "hub-rg"
  resource_group_location = "West Europe"
  hub_vnet_name               = "prod-hub-vnet"
  hub_vnet_address_space      = "10.0.0.0/16"
  firewall_address_space  = "10.0.1.0/24"
  hub_vnet_subnets = {
    "hub-subnet"  = "10.0.0.0/24"
    "app-subnet"  = "10.0.2.0/24"
    "db-subnet"   = "10.0.3.0/24"
  }
  providers = {
    azurerm.hub = azurerm.hub
  }

}

module "dev" {
  source = "./resources/spoke"

  resource_group_name     = "dev-rg"
  resource_group_location = "West Europe"
  hub_vnet_name = module.hub.hub_vnet_name
  hub_vnet_id = module.hub.hub_vnet_id
  firewall_private_ip  = module.hub.firewall_private_ip
  hub_resource_group = module.hub.resource_group_name
  spoke_vnet_name               = "dev-vnet"
  spoke_vnet_address_space      = "10.1.0.0/16"
  spoke_vnet_subnets = {
    "default"  = "10.1.0.0/24"
    "app-subnet"  = "10.1.2.0/24"
    "db-subnet"   = "10.1.3.0/24"
  }
  providers = {
    azurerm.spoke = azurerm.spoke
    azurerm.hub = azurerm.hub
  }
}

module "staging" {
  source = "./resources/spoke"

  resource_group_name     = "staging-rg"
  resource_group_location = "West US"
  hub_vnet_name = module.hub.hub_vnet_name
  hub_vnet_id = module.hub.hub_vnet_id
  hub_resource_group = module.hub.resource_group_name
  firewall_private_ip  = module.hub.firewall_private_ip
  spoke_vnet_name               = "staging-vnet"
  spoke_vnet_address_space      = "10.2.0.0/16"
  spoke_vnet_subnets = {
    "default"  = "10.2.0.0/24"
    "app-subnet"  = "10.2.2.0/24"
    "db-subnet"   = "10.2.3.0/24"
  }
  providers = {
    azurerm.spoke = azurerm.spoke
    azurerm.hub = azurerm.hub
  }
}

module "production" {
  source = "./resources/spoke"

  resource_group_name     = "production-rg"
  resource_group_location = "West US"
  hub_vnet_name = module.hub.hub_vnet_name
  hub_vnet_id = module.hub.hub_vnet_id
  hub_resource_group = module.hub.resource_group_name
  firewall_private_ip  = module.hub.firewall_private_ip
  spoke_vnet_name               = "production-vnet"
  spoke_vnet_address_space      = "10.3.0.0/16"
  spoke_vnet_subnets = {
    "default"  = "10.3.0.0/24"
    "app-subnet"  = "10.3.2.0/24"
    "db-subnet"   = "10.3.3.0/24"
  }
  providers = {
    azurerm.spoke = azurerm.hub   #prod in hub subscription
    azurerm.hub = azurerm.hub
  }
}

module "network_firewall_rule" {
  source = "./resources/firewall"
  collection_name = "allow-spoke-to-spoke"
  firewall_rule_type           = "network"
  azure_firewall_name = module.hub.firewall_name
  resource_group_name = module.hub.resource_group_name
  resource_group_location = module.hub.resource_group_location
  priority            = 100

  rules = [
    {
      name                  = "allow dev to staging"
      source_addresses      = module.dev.spoke_vnet_cidr
      destination_ports     = ["22"]
      destination_addresses = module.staging.spoke_vnet_cidr
      protocols             = ["TCP"]
    },
    {
      name                  = "allow staging to dev"
      source_addresses      = module.staging.spoke_vnet_cidr
      destination_ports     = ["22"]
      destination_addresses = module.dev.spoke_vnet_cidr
      protocols             = ["TCP"]
    }
  ]

  providers = {
    azurerm.spoke = azurerm.spoke
    azurerm.hub = azurerm.hub
  }
}


module "firewall_nat_rules" {
  source              = "./resources/firewall"
  collection_name = "allow-everyone-to-hub"
  firewall_rule_type           = "nat"
  azure_firewall_name = module.hub.firewall_name
  resource_group_name = module.hub.resource_group_name
  resource_group_location = module.hub.resource_group_location
  priority            = 200

  rules = [
    {
      name                = "dnat rule 1"
      source_addresses    = ["0.0.0.0/0"]
      destination_ports   = ["22"]
      destination_addresses = ["${module.hub.firewall_public_ip}"]
      translated_address  = "10.0.0.4"
      translated_port     = "22"
      protocols           = ["TCP"]
    }
  ]
  providers = {
    azurerm.spoke = azurerm.spoke
    azurerm.hub = azurerm.hub
  }
}


module "firewall_app_rules" {
  source              = "./resources/firewall"
  collection_name = "allow-access-to-google"
  firewall_rule_type           = "app"
  azure_firewall_name = module.hub.firewall_name
  resource_group_name = module.hub.resource_group_name
  resource_group_location = module.hub.resource_group_location
  priority            = 300

  rules = [
      {
        name             = "Allow-GitHub"
        source_addresses = ["10.0.1.0/24"]
        target_fqdns     = ["github.com"]
        app_rule_protocols = [
          { port = 443, type = "Https" },
          { port = 80, type = "Http" }
        ]
      },
      {
        name             = "Allow-Google"
        source_addresses = ["10.0.3.0/24"]
        target_fqdns     = ["google.com"]
        app_rule_protocols = [
          { port = 443, type = "Https" }
        ]
      }
    ]
  providers = {
    azurerm.spoke = azurerm.spoke
    azurerm.hub = azurerm.hub
  }
}