output "subnet_ids" {
  value = module.vnet.subnet_ids
}

output "acr_private_endpoint_ip" {
  value = var.enable_acr_private_endpoint ? azurerm_private_endpoint.fk_acr_pe[0].private_service_connection[0].private_ip_address : null
}