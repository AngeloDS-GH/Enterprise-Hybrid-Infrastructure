# ==============================================================================
# File: terraform/01_networking.tf
# Description: Provisions Hub-and-Spoke VNet Topology for DmonTech
# ==============================================================================

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1. Resource Group
resource "azurerm_resource_group" "rg_network" {
  name     = "rg-dmontech-network-prod"
  location = "eastus"
  tags = {
    Environment = "Production"
    Project     = "Enterprise-Hybrid-Infrastructure"
    ManagedBy   = "Terraform"
  }
}

# 2. Virtual Networks
resource "azurerm_virtual_network" "vnet_hub" {
  name                = "vnet-hub-eastus-01"
  location            = azurerm_resource_group.rg_network.location
  resource_group_name = azurerm_resource_group.rg_network.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "vnet_spoke_prod" {
  name                = "vnet-spoke-prod-eastus-01"
  location            = azurerm_resource_group.rg_network.location
  resource_group_name = azurerm_resource_group.rg_network.name
  address_space       = ["10.1.0.0/16"]
}

# 3. Subnets - Hub
resource "azurerm_subnet" "subnet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "subnet_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_hub.name
  address_prefixes     = ["10.0.1.0/26"]
}

# 4. Subnets - Spoke
resource "azurerm_subnet" "subnet_app" {
  name                 = "snet-app-prod-01"
  resource_group_name  = azurerm_resource_group.rg_network.name
  virtual_network_name = azurerm_virtual_network.vnet_spoke_prod.name
  address_prefixes     = ["10.1.1.0/24"]
}

# 5. VNet Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-hub-to-spoke-prod"
  resource_group_name          = azurerm_resource_group.rg_network.name
  virtual_network_name         = azurerm_virtual_network.vnet_hub.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_spoke_prod.id
  allow_virtual_network_access = true
}