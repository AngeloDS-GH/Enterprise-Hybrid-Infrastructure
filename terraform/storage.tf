# ============================================================
# DmonTech Enterprise Hybrid Infrastructure
# Azure Storage
# ============================================================


# ============================================================
# Storage Account
# ============================================================

resource "azurerm_storage_account" "spoke" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.spoke.name
  location                 = azurerm_resource_group.spoke.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = merge(
    var.common_tags,
    {
      Component = "Secure-Storage"
    }
  )
}


# ============================================================
# Azure Files
# ============================================================

resource "azurerm_storage_share" "dmontech_files" {
  name               = var.file_share_name
  storage_account_id = azurerm_storage_account.spoke.id

  quota = 102400
}


# ============================================================
# Blob Containers
# ============================================================

resource "azurerm_storage_container" "app_data" {
  name                  = var.app_data_container_name
  storage_account_id    = azurerm_storage_account.spoke.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "archive" {
  name                  = var.archive_container_name
  storage_account_id    = azurerm_storage_account.spoke.id
  container_access_type = "private"
}


# ============================================================
# Private DNS Zone - Blob Storage
# ============================================================

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.spoke.name

  tags = merge(
    var.common_tags,
    {
      Component = "Private-DNS"
    }
  )
}


# ============================================================
# Private DNS Zone Link
# ============================================================

resource "azurerm_private_dns_zone_virtual_network_link" "blob_spoke" {
  name                  = "link-blob-spoke"
  resource_group_name   = azurerm_resource_group.spoke.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.spoke.id

  registration_enabled = false

  tags = merge(
    var.common_tags,
    {
      Component = "Private-DNS"
    }
  )
}


# ============================================================
# Storage Private Endpoint
# ============================================================

resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pe-${var.storage_account_name}-blob"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  subnet_id           = azurerm_subnet.workload.id

  private_service_connection {
    name                           = "psc-${var.storage_account_name}-blob"
    private_connection_resource_id = azurerm_storage_account.spoke.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "blob-private-dns-zone-group"

    private_dns_zone_ids = [
      azurerm_private_dns_zone.blob.id
    ]
  }

  tags = merge(
    var.common_tags,
    {
      Component = "Storage-Private-Endpoint"
    }
  )
}


# ============================================================
# Storage Lifecycle Management
# ============================================================

resource "azurerm_storage_management_policy" "lifecycle" {
  storage_account_id = azurerm_storage_account.spoke.id

  rule {
    name    = "lifecycle-archive-data"
    enabled = true

    filters {
      prefix_match = [
        "${var.archive_container_name}/"
      ]

      blob_types = [
        "blockBlob"
      ]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 30
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }
    }
  }
}