# ============================================================
# Azure Subscription
# ============================================================

variable "subscription_id" {
  description = "Azure Subscription ID used to deploy the DmonTech infrastructure."
  type        = string
  sensitive   = true
}


# ============================================================
# General Configuration
# ============================================================

variable "location" {
  description = "Primary Azure region for the DmonTech environment."
  type        = string
  default     = "East US 2"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project identifier used for tagging and resource organization."
  type        = string
  default     = "dmontech"
}


# ============================================================
# Resource Groups
# ============================================================

variable "hub_resource_group_name" {
  description = "Resource Group containing the Hub networking infrastructure."
  type        = string
  default     = "rg-dmontech-net-prod-01"
}

variable "spoke_resource_group_name" {
  description = "Resource Group containing the Spoke workloads."
  type        = string
  default     = "rg-spoke-prod-01"
}


# ============================================================
# Hub Network
# ============================================================

variable "hub_vnet_name" {
  description = "Name of the Hub Virtual Network."
  type        = string
  default     = "vnet-hub-prod-01"
}

variable "hub_address_space" {
  description = "Address space assigned to the Hub Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "azure_firewall_subnet_prefix" {
  description = "Address prefix assigned to AzureFirewallSubnet."
  type        = string
  default     = "10.0.1.0/26"
}

variable "azure_firewall_management_subnet_prefix" {
  description = "Address prefix assigned to AzureFirewallManagementSubnet."
  type        = string
  default     = "10.0.1.64/26"
}

variable "gateway_subnet_prefix" {
  description = "Address prefix assigned to GatewaySubnet."
  type        = string
  default     = "10.0.0.0/27"
}


# ============================================================
# Spoke Network
# ============================================================

variable "spoke_vnet_name" {
  description = "Name of the workload Spoke Virtual Network."
  type        = string
  default     = "vnet-spk-workloads-01"
}

variable "spoke_address_space" {
  description = "Address space assigned to the workload Spoke Virtual Network."
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "workload_subnet_name" {
  description = "Name of the subnet hosting application workloads."
  type        = string
  default     = "snet-app-01"
}

variable "workload_subnet_prefix" {
  description = "Address prefix assigned to the application workload subnet."
  type        = string
  default     = "10.1.1.0/24"
}

variable "application_gateway_subnet_name" {
  description = "Name of the dedicated Application Gateway subnet."
  type        = string
  default     = "snet-appgw-01"
}

variable "application_gateway_subnet_prefix" {
  description = "Address prefix assigned to the Application Gateway subnet."
  type        = string
  default     = "10.1.2.0/24"
}


# ============================================================
# Network Security
# ============================================================

variable "workload_nsg_name" {
  description = "Network Security Group protecting the application workload subnet."
  type        = string
  default     = "nsg-app-prod-01"
}

variable "spoke_route_table_name" {
  description = "Route table used to control outbound traffic from the Spoke."
  type        = string
  default     = "rt-spoke-to-hub-01"
}


# ============================================================
# Azure Firewall
# ============================================================

variable "firewall_name" {
  description = "Name of the centralized Azure Firewall."
  type        = string
  default     = "afw-hub-prod-01"
}

variable "firewall_policy_name" {
  description = "Name of the Azure Firewall Policy."
  type        = string
  default     = "pol-afw-hub-prod-01"
}


# ============================================================
# Storage
# ============================================================

variable "storage_account_name" {
  description = "Name of the DmonTech workload Storage Account."
  type        = string
  default     = "stspokeprod01"
}

variable "file_share_name" {
  description = "Name of the Azure Files share."
  type        = string
  default     = "dmontech-files"
}

variable "app_data_container_name" {
  description = "Blob container used for application data."
  type        = string
  default     = "app-data"
}

variable "archive_container_name" {
  description = "Blob container used for archival data."
  type        = string
  default     = "archive"
}


# ============================================================
# Common Tags
# ============================================================

variable "common_tags" {
  description = "Common tags applied to DmonTech Azure resources."
  type        = map(string)

  default = {
    Project     = "DmonTech"
    Environment = "Production"
    ManagedBy   = "Terraform"
    Purpose     = "Enterprise-Hybrid-Infrastructure-Lab"
  }
}