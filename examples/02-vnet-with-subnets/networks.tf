module "vnet" {
  source = "git::https://github.com/mlinxfeld/terraform-az-fk-vnet.git?ref=v0.1.0"

  name                = var.vnet_name
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  address_space = ["10.10.0.0/16"]

  subnets = {
    fk-subnet-public = {
      address_prefixes = ["10.10.0.0/24"]
    }

    fk-subnet-private = {
      address_prefixes  = ["10.10.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }

    fk-subnet-apps = {
      address_prefixes = ["10.10.2.0/24"]
    }
  }

  tags = var.tags
}