# Optional: Private DNS for ACR Private Endpoint
# ACR Private Link uses: privatelink.azurecr.io

module "private_dns" {
  source = "github.com/mlinxfeld/terraform-az-fk-private-dns"
  count  = var.enable_acr_private_endpoint && var.enable_private_dns ? 1 : 0

  resource_group_name    = azurerm_resource_group.foggykitchen_rg.name
  private_dns_zone_names = ["privatelink.azurecr.io"]
  tags                   = var.tags

  vnet_links = {
    "acr-dns-link" = {
      vnet_id              = module.vnet.vnet_id
      registration_enabled = false
    }
  }
}

module "private_endpoint_acr" {
  source = "github.com/mlinxfeld/terraform-az-fk-private-endpoint"
  count  = var.enable_acr_private_endpoint ? 1 : 0

  name                = "fk-acr-pe"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  subnet_id           = module.vnet.subnet_ids["fk-subnet-private-endpoints"]

  private_connection_resource_id = azurerm_container_registry.foggykitchen_acr.id
  subresource_names              = ["registry"]
  is_manual_connection           = false

  private_dns_zone_group_name = "acr-dns-zone-group"
  private_dns_zone_ids        = var.enable_private_dns ? [module.private_dns[0].private_dns_zone_ids["privatelink.azurecr.io"]] : []

  tags = var.tags

  depends_on = [
    module.private_dns
  ]
}
