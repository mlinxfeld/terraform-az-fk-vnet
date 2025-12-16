variable "resource_group_name" {
  description = "The name of the Azure Resource Group where resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region (e.g., East US, West Europe)"
  type        = string
}

variable "vnet_name" {
  type    = string
  default = "fk-vnet-basic"
}

variable "tags" {
  type    = map(string)
  default = {
    project = "foggykitchen"
    env     = "dev"
    example = "01-basic-vnet"
  }
}