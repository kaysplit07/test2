terraform {
  backend "azurerm" {
    resource_group_name   = var.resource_group_name
    storage_account_name  = var.storage_account_name
    container_name        = "terraform-state"
    key                   = "${var.resource_type}/${var.resource_name}.tfstate"
  }
}


variable "resource_group_name" {
  description = "Resource group name for Terraform backend"
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name for Terraform backend"
  type        = string
}

variable "resource_type" {
  description = "Type of resource for organizing state files"
  type        = string
  default     = "loadbalancer"
}

variable "resource_name" {
  description = "Dynamically generated resource name based on naming standards"
  type        = string
  default     = join("-", ["ari", local.naming.environment, local.env_location.locations_abbreviation, local.purpose_rg, "lbi", local.sequence])
}
