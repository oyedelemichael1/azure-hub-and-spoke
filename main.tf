module "hub_and_spkoke" {
  source = "./resources/network"

  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  hub_vnet_name               = "prod-hub-vnet"
  hub_vnet_address_space      = "10.0.0.0/16"
  hub_vnet_subnets = {
    "hub-subnet"  = "10.0.0.0/24"
    "app-subnet"  = "10.0.2.0/24"
    "db-subnet"   = "10.0.3.0/24"
  }
  spoke_vnets = {
    "spoke1" = {
      address_space = "10.1.0.0/16"
      subnets = {
        "default"  = {cidr_block = "10.1.0.0/24"}
        "app"      = {cidr_block = "10.1.1.0/24"}
      }
    },
    "spoke2" = {
      address_space = "10.2.0.0/16"
      subnets = {
        "default"  = {cidr_block = "10.2.0.0/24"}
        "database" = {cidr_block = "10.2.1.0/24"}
      }
    }
  }
}
