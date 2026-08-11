# ============================================================
# DmonTech Enterprise Hybrid Infrastructure
# Network Security
# ============================================================


# ============================================================
# Workload Network Security Group
# ============================================================

resource "azurerm_network_security_group" "workload" {
  name                = var.workload_nsg_name
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  tags = merge(
    var.common_tags,
    {
      Component = "Network-Security"
    }
  )
}


# ============================================================
# Allow HTTP Traffic
# ============================================================

resource "azurerm_network_security_rule" "allow_http" {
  name                       = "Allow-HTTP"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.spoke.name
  network_security_group_name = azurerm_network_security_group.workload.name
}


# ============================================================
# Allow HTTPS Traffic
# ============================================================

resource "azurerm_network_security_rule" "allow_https" {
  name                       = "Allow-HTTPS"
  priority                   = 110
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.spoke.name
  network_security_group_name = azurerm_network_security_group.workload.name
}


# ============================================================
# Associate NSG with Workload Subnet
# ============================================================

resource "azurerm_subnet_network_security_group_association" "workload" {
  subnet_id                 = azurerm_subnet.workload.id
  network_security_group_id = azurerm_network_security_group.workload.id
}


# ============================================================
# Azure Firewall Policy
# ============================================================

resource "azurerm_firewall_policy" "hub" {
  name                = var.firewall_policy_name
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location

  sku = "Standard"

  tags = merge(
    var.common_tags,
    {
      Component = "Centralized-Security"
    }
  )
}


# ============================================================
# Azure Firewall Public IP
# ============================================================

resource "azurerm_public_ip" "firewall" {
  name                = "pip-afw-hub-prod-01"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = merge(
    var.common_tags,
    {
      Component = "Azure-Firewall"
    }
  )
}


# ============================================================
# Azure Firewall Management Public IP
# ============================================================

resource "azurerm_public_ip" "firewall_management" {
  name                = "pip-afw-mgmt-prod-01"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = merge(
    var.common_tags,
    {
      Component = "Azure-Firewall-Management"
    }
  )
}


# ============================================================
# Azure Firewall
# ============================================================

resource "azurerm_firewall" "hub" {
  name                = var.firewall_name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  firewall_policy_id = azurerm_firewall_policy.hub.id

  ip_configuration {
    name                 = "afw-ipconfig"
    subnet_id            = azurerm_subnet.azure_firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  management_ip_configuration {
    name                 = "afw-management-ipconfig"
    subnet_id            = azurerm_subnet.azure_firewall_management.id
    public_ip_address_id = azurerm_public_ip.firewall_management.id
  }

  tags = merge(
    var.common_tags,
    {
      Component = "Centralized-Firewall"
    }
  )
}