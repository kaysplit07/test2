variable "environment_map" {
  type = map
  description = "environment"
  default = {
    "dev"  = "dev"
    "uat" = "uat"
    "fof" = "fof"
    "prod" = "prod"
    "qa" = "qa"
  }
}

variable "location_map" {
  type = map
  description = "location_map"
    default = {
    "eastus2"  = "eus2"
    "centralus" = "cus"
    "uksouth" = "uks"
    "ukwest" = "ukw"
    "us"= "eus2"
  
  }

}

variable "sku_name" {
  description = "SKU name for the Load Balancer."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.sku_name)
    error_message = "sku_name must be either 'Basic' or 'Standard'."
  }
}

variable "location" {
  type = string
  description = "location"
  default = "eastus2"
}


variable "purpose_rg" {
  type        = string
  default     = "default"
  description = "(Required) The purpose segment of the Resource Group name. Should not exceed 5 characters."
  validation {
    condition     = strcontains(var.purpose_rg, "-") ? length(var.purpose_rg) <= 80 : length(var.purpose_rg) <= 5
    error_message = "(Required) Purpose segment cannot exceed 5 characters. Name cannot exceed 80."
  }  
 }