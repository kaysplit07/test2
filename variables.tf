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


variable "purposeRG" {
  type        = string
  default     = "default"
  description = "(Required) The purpose segment of the Resource Group name. Should not exceed 5 characters."
  validation {
    condition     = strcontains(var.purposeRG, "-") ? length(var.purposeRG) <= 80 : length(var.purposeRG) <= 5
    error_message = "(Required) Purpose segment cannot exceed 5 characters. Name cannot exceed 80."
  }  
 }



# Define the name for the subnet
variable "subnetname" {
  description = "The name of the subnet to be used in the virtual network."
  type        = string
}

variable "private_ip_address" {
  description = "The private IP address to assign to the load balancer frontend configuration."
  type        = string
  default     = "10.82.58.234"  # You can change the default value as needed
}

variable "purpose" {
  description = "Purpose of the resources, used in naming conventions."
  type        = string
}



