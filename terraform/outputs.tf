# ============================================================
# DmonTech Enterprise Hybrid Infrastructure
# Terraform Outputs
# ============================================================


# ============================================================
# Resource Groups
# ============================================================

output "hub_resource_group_name" {
  description = "Name of the Hub Resource Group."
  value       = azurerm_resource_group.hub.name
}

output "spoke_resource_group_name" {
  description = "Name of the Spoke Resource Group."
  value       = azurerm_resource_group.spoke.name
}


# ============================================================
# Hub Network
# ============================================================

output "hub_vnet_name" {
  description = "Name of the Hub Virtual Network."
  value       = azurerm_virtual_network.hub.name
}

output "hub_vnet_id" {
  description = "Resource ID of the Hub Virtual Network."
  value       = azurerm_virtual_network.hub.id
}

output "hub_address_space" {
  description = "Address space assigned to the Hub Virtual Network."
  value       = azurerm_virtual_network.hub.address_space
}


# ============================================================
# Spoke Network
# ============================================================

output "spoke_vnet_name" {
  description = "Name of the Spoke Virtual Network."
  value       = azurerm_virtual_network.spoke.name
}

output "spoke_vnet_id" {
  description = "Resource ID of the Spoke Virtual Network."
  value       = azurerm_virtual_network.spoke.id
}

output "spoke_address_space" {
  description = "Address space assigned to the Spoke Virtual Network."
  value       = azurerm_virtual_network.spoke.address_space
}

output "workload_subnet_id" {
  description = "Resource ID of the application workload subnet."
  value       = azurerm_subnet.workload.id
}

output "application_gateway_subnet_id" {
  description = "Resource ID of the dedicated Application Gateway subnet."
  value       = azurerm_subnet.application_gateway.id
}


# ============================================================
# Network Security
# ============================================================

output "workload_nsg_name" {
  description = "Name of the Network Security Group protecting the workload subnet."
  value       = azurerm_network_security_group.workload.name
}

output "workload_nsg_id" {
  description = "Resource ID of the workload Network Security Group."
  value       = azurerm_network_security_group.workload.id
}

output "spoke_route_table_name" {
  description = "Name of the Spoke route table."
  value       = azurerm_route_table.spoke.name
}


# ============================================================
# Azure Firewall
# ============================================================

output "azure_firewall_name" {
  description = "Name of the centralized Azure Firewall."
  value       = azurerm_firewall.hub.name
}

output "azure_firewall_private_ip" {
  description = "Private IP address assigned to the Azure Firewall."
  value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}

output "azure_firewall_public_ip" {
  description = "Public IP address assigned to the Azure Firewall."
  value       = azurerm_public_ip.firewall.ip_address
}

output "firewall_policy_id" {
  description = "Resource ID of the Azure Firewall Policy."
  value       = azurerm_firewall_policy.hub.id
}


# ============================================================
# Storage
# ============================================================

output "storage_account_name" {
  description = "Name of the secure DmonTech Storage Account."
  value       = azurerm_storage_account.spoke.name
}

output "storage_account_id" {
  description = "Resource ID of the DmonTech Storage Account."
  value       = azurerm_storage_account.spoke.id
}

output "azure_files_share_name" {
  description = "Name of the Azure Files share."
  value       = azurerm_storage_share.dmontech_files.name
}

output "app_data_container_name" {
  description = "Name of the application data Blob container."
  value       = azurerm_storage_container.app_data.name
}

output "archive_container_name" {
  description = "Name of the archival Blob container."
  value       = azurerm_storage_container.archive.name
}


# ============================================================
# Private Connectivity
# ============================================================

output "storage_private_endpoint_id" {
  description = "Resource ID of the Storage Blob Private Endpoint."
  value       = azurerm_private_endpoint.storage_blob.id
}

output "blob_private_dns_zone_name" {
  description = "Private DNS Zone used for Azure Blob Storage."
  value       = azurerm_private_dns_zone.blob.name
}


# ============================================================
# Deployment Information
# ============================================================

output "deployment_location" {
  description = "Primary Azure region used by the DmonTech deployment."
  value       = var.location
}

output "deployment_environment" {
  description = "Environment represented by this Terraform deployment."
  value       = var.environment
}

output "project_name" {
  description = "Name of the infrastructure project."
  value       = var.project_name
}