variable "name" {
  description = "Base name for the VNet"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "address_space" {
  description = "CIDR blocks for the VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])

    delegations = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })), [])

    private_endpoint_network_policies = optional(string, "Enabled") # "Enabled" or "Disabled"

    # In azurerm v4 this is still a bool flag
    private_link_service_network_policies_enabled = optional(bool, true)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "dns_servers" {
  description = "Custom DNS servers for the VNet"
  type        = list(string)
  default     = []
}

variable "enable_ddos_protection" {
  type    = bool
  default = false
}

variable "ddos_protection_plan_id" {
  type    = string
  default = null
}