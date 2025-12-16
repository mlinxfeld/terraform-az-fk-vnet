output "subnet_ids" {
  value = module.vnet.subnet_ids
}

output "acr_private_endpoint_ip" {
  value = azurerm_private_endpoint.fk_acr_pe.private_service_connection[0].private_ip_address
}