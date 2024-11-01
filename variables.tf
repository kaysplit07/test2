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

variable "RGname" {
  description = "Optional existing Resource Group name. If not provided, it will be computed."
  type        = string
  default     = ""
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

# Define the name for the subnet
variable "subnetname" {
  type = string
  default = "5874-dev-eus2-aks-snet-02"
#  sensitive = true
  
}

variable "private_ip_address" {
  description = "The private IP address to assign to the load balancer frontend configuration."
  type        = string
  default     = "10.82.58.234"  # You can change the default value as needed
}

variable "purpose" {
  type        = string
  default     = "default"
  description = "(Required) The LB Role and Sequence for naming use or, submit the desired resource name (one that contains a dash)."
  validation {
    condition     = strcontains(var.purpose, "-") ? length(var.purpose) <= 30 : length(var.purpose) <= 10
    error_message = "(Required) Purpose [LB Role.Sequence] segment cannot exceed 10 characters. Name cannot exceed 80."
  }
 }
