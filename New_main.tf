# Provider and Data Sources
provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "clientconfig" {}

# Local Variables
locals {
  get_data = csvdecode(file("../parameters.csv"))

    naming = {
    bu                = lower(split("-", data.azurerm_subscription.current.display_name)[1])
    environment       = lower(split("-", data.azurerm_subscription.current.display_name)[2])
    locations         = var.location
    nn                = lower(split("-", data.azurerm_subscription.current.display_name)[3])
    subscription_name = data.azurerm_subscription.current.display_name
    subscription_id   = data.azurerm_subscription.current.id
  }

  env_location = {
    env_abbreviation       = var.environment_map[local.naming.environment]
    locations_abbreviation = var.location_map[local.naming.locations]
  }

  purposeRG = var.purposeRG
}

data "azurerm_resource_group" "rg" {
  for_each = { for inst in local.get_data : inst.unique_id => inst }
  name     = join("-", [local.naming.bu, local.naming.environment, local.env_location.locations_abbreviation, local.purposeRG, "rg"])
}

data "azurerm_resource_group" "vnet" {
  name     = "6425-DEV-eus2-spokenetwork-rg"
}
# Virtual Network and Subnet Data Sources
data "azurerm_virtual_network" "vnet" {
  #for_each = { for inst in local.get_data : inst.unique_id => inst }
  name = "6425-dev-eus2-vnet-01"
  #location = data.azurerm_resource_group.vnet_rg.location
  #resource_group_name = data.azurerm_resource_group.rg[each.key].name
  resource_group_name = data.azurerm_resource_group.vnet.name

}

data "azurerm_subnet" "subnet" {
  #for_each = { for inst in local.get_data : inst.unique_id => inst }
  #name                 = lookup(each.value, "subnetName", var.subnetName)
  name = "lz6425-dev-eus2-vm-snet-01"
  #virtual_network_name = data.azurerm_virtual_network.vnet[each.key].name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  #resource_group_name  = data.azurerm_resource_group.rg[each.key].name
  resource_group_name = "6425-DEV-eus2-spokenetwork-rg"
}

# Random ID for Naming Uniqueness
resource "random_id" "randomnumber" {
  byte_length = 1
}

# # Azure Load Balancer Resource
# resource "azurerm_lb" "internal_lb" {
#   for_each = { for inst in local.get_data : inst.unique_id => inst }
#   name                = join("-", ["ari", local.naming.environment, local.env_location.locations_abbreviation, local.purposeRG, "lbi", random_id.randomnumber.hex])
#   location            = var.location
#   resource_group_name = data.azurerm_resource_group.rg[each.key].name
#   sku                 = (lookup(each.value,"sku_name",null) != null && lookup(each.value,"sku_name","") != "") ? each.value.sku_name : var.sku_name

#   frontend_ip_configuration {
#     name                          = "internal-${local.purposeRG}-server-feip"
#     subnet_id                     = data.azurerm_subnet.subnet[each.key].id
#     private_ip_address            = "10.82.58.233"
#     private_ip_address_allocation = "Static"
#   }

# #   backend_address_pool {
# #     name = "internal-${local.purposeRG}-server-bepool"
# #   }
# # }

# # Load Balancer Probe
# resource "azurerm_lb_probe" "tcp_probe" {
#   for_each = azurerm_lb.internal_lb
#   name                = "internal-${local.purposeRG}-server-tcp-probe"
#   resource_group_name = azurerm_lb.internal_lb[each.key].resource_group_name
#   loadbalancer_id     = azurerm_lb.internal_lb[each.key].id
#   protocol            = "Tcp"
#   port                = 20000
#   interval_in_seconds = 10
#   number_of_probes    = 5
# }

# # Load Balancer TCP Rule
# resource "azurerm_lb_rule" "tcp_rule" {
#   for_each = azurerm_lb.internal_lb
#   name                           = "internal-${local.purposeRG}-server-tcp-lbrule"
#   resource_group_name            = azurerm_lb.internal_lb[each.key].resource_group_name
#   loadbalancer_id                = azurerm_lb.internal_lb[each.key].id
#   protocol                       = "Tcp"
#   frontend_port                  = 20000
#   backend_port                   = 20000
#   frontend_ip_configuration_name = azurerm_lb.internal_lb[each.key].frontend_ip_configuration[0].name
#   backend_address_pool_id        = azurerm_lb.internal_lb[each.key].backend_address_pool[0].id
#   idle_timeout_in_minutes        = 5
#   enable_floating_ip             = false
#   enable_tcp_reset               = false
#   disable_outbound_snat          = false
#   probe_id                       = azurerm_lb_probe.tcp_probe[each.key].id
# }


# Azure Load Balancer Resource
resource "azurerm_lb" "internal_lb" {
  for_each            = { for inst in local.get_data : inst.unique_id => inst }
  name                = join("-", ["ari", local.naming.environment, local.env_location.locations_abbreviation, local.purposeRG, "lbi", random_id.randomnumber.hex])
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
  sku                 = (lookup(each.value,"sku_name",null) != null && lookup(each.value,"sku_name","") != "") ? each.value.sku_name : var.sku_name

  frontend_ip_configuration {
    name                          = "internal-${local.purposeRG}-server-feip"
    #subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    subnet_id                      = data.azurerm_subnet.subnet.id
    private_ip_address            = "10.82.58.234"
    private_ip_address_allocation = "Static"
  }
}

# Define Backend Address Pool separately
resource "azurerm_lb_backend_address_pool" "internal_lb_bepool" {
  for_each            = azurerm_lb.internal_lb
  loadbalancer_id     = azurerm_lb.internal_lb[each.key].id
  #resource_group_name = azurerm_lb.internal_lb[each.key].resource_group_name
  name                = "internal-${local.purposeRG}-server-bepool"
}

# Load Balancer Probe
resource "azurerm_lb_probe" "tcp_probe" {
  for_each            = azurerm_lb.internal_lb
  name                = "internal-${local.purposeRG}-server-tcp-probe"
  loadbalancer_id     = azurerm_lb.internal_lb[each.key].id
  protocol            = "Tcp"
  port                = 20000
  interval_in_seconds = 10
  number_of_probes    = 5
}


# Load Balancer TCP Rule
resource "azurerm_lb_rule" "tcp_rule" {
  for_each                       = azurerm_lb.internal_lb
  name                           = "internal-${local.purposeRG}-server-tcp-lbrule"
  #resource_group_name            = azurerm_lb.internal_lb[each.key].resource_group_name
  loadbalancer_id                = azurerm_lb.internal_lb[each.key].id
  protocol                       = "Tcp"
  frontend_port                  = 20000
  backend_port                   = 20000
  frontend_ip_configuration_name = azurerm_lb.internal_lb[each.key].frontend_ip_configuration[0].name
  #backend_address_pool_ids        = ["azurerm_lb_backend_address_pool.internal_lb_bepool[each.key].id"]
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.internal_lb_bepool[each.key].id] 
  idle_timeout_in_minutes        = 5
  enable_floating_ip             = false
  enable_tcp_reset               = false
  disable_outbound_snat          = false
  probe_id                       = azurerm_lb_probe.tcp_probe[each.key].id
}
# Load Balancer HTTPS Rule
resource "azurerm_lb_rule" "https_rule" {
  for_each = azurerm_lb.internal_lb
  name                           = "internal-${local.purposeRG}-server-https-lbrule"
  #resource_group_name            = azurerm_lb.internal_lb[each.key].resource_group_name
  loadbalancer_id                = azurerm_lb.internal_lb[each.key].id
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = azurerm_lb.internal_lb[each.key].frontend_ip_configuration[0].name
  #backend_address_pool_ids        = ["azurerm_lb.internal_lb[each.key].backend_address_pool[0].id"]
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.internal_lb_bepool[each.key].id] # Corrected here
  idle_timeout_in_minutes        = 4
  enable_floating_ip             = false
  enable_tcp_reset               = false
  disable_outbound_snat          = false
  probe_id                       = azurerm_lb_probe.tcp_probe[each.key].id
}
