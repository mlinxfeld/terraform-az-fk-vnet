# Optional: Private DNS for ACR Private Endpoint
# ACR Private Link uses: privatelink.azurecr.io

resource "azurerm_private_dns_zone" "foggykitchen_acr_dns_zone" {
  count               = var.enable_acr_private_endpoint && var.enable_private_dns ? 1 : 0
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "foggykitchen_acr_dns_zone_link" {
  count                 = var.enable_acr_private_endpoint && var.enable_private_dns ? 1 : 0
  name                  = "acr-dns-link"
  resource_group_name   = azurerm_resource_group.foggykitchen_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.foggykitchen_acr_dns_zone[0].name
  virtual_network_id    = module.vnet.vnet_id

  tags = var.tags
}

resource "azurerm_private_endpoint" "fk_acr_pe" {
  count               = var.enable_acr_private_endpoint ? 1 : 0
  name                = "fk_acr_pe"
  location            = azurerm_resource_group.foggykitchen_rg.location
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name

  subnet_id = module.vnet.subnet_ids["fk-subnet-private-endpoints"]

  private_service_connection {
    name                           = "fk_acr_connection"
    private_connection_resource_id = azurerm_container_registry.foggykitchen_acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  # Attach PE to Private DNS zone (optional)
  dynamic "private_dns_zone_group" {
    for_each = var.enable_private_dns ? [1] : []
    content {
      name                 = "acr-dns-zone-group"
      private_dns_zone_ids = [azurerm_private_dns_zone.foggykitchen_acr_dns_zone[0].id]
    }
  }

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.foggykitchen_acr_dns_zone_link
  ]
}

