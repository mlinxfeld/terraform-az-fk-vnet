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

  tags = var.tags
}
