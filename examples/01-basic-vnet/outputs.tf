output "vnet_id" {
  description = "ID of the created Virtual Network"
  value       = module.vnet.vnet_id
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value       = module.vnet.subnet_ids
}
