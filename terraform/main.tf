# ============================================================
# DmonTech Enterprise Hybrid Infrastructure
# Core Resources
# ============================================================


# ============================================================
# Hub Resource Group
# ============================================================

resource "azurerm_resource_group" "hub" {
  name     = var.hub_resource_group_name
  location = var.location

  tags = merge(
    var.common_tags,
    {
      Component = "Hub-Networking"
    }
  )
}


# ============================================================
# Spoke Resource Group
# ============================================================

resource "azurerm_resource_group" "spoke" {
  name     = var.spoke_resource_group_name
  location = var.location

  tags = merge(
    var.common_tags,
    {
      Component = "Spoke-Workloads"
    }
  )
}