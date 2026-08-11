# ============================================================
# DmonTech Enterprise Hybrid Infrastructure
# Hub-Spoke Networking
# ============================================================


# ============================================================
# Hub Virtual Network
# ============================================================

resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = var.hub_address_space

  tags = merge(
    var.common_tags,
    {
      Component = "Hub-Network"
    }
  )
}


# ============================================================
# Hub Subnets
# ============================================================

resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

resource "azurerm_subnet" "azure_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.azure_firewall_subnet_prefix]
}

resource "azurerm_subnet" "azure_firewall_management" {
  name                 = "AzureFirewallManagementSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.azure_firewall_management_subnet_prefix]
}


# ============================================================
# Spoke Virtual Network
# ============================================================

resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet_name
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  address_space       = var.spoke_address_space

  tags = merge(
    var.common_tags,
    {
      Component = "Spoke-Network"
    }
  )
}


# ============================================================
# Spoke Subnets
# ============================================================

resource "azurerm_subnet" "workload" {
  name                 = var.workload_subnet_name
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.workload_subnet_prefix]
}

resource "azurerm_subnet" "application_gateway" {
  name                 = var.application_gateway_subnet_name
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.application_gateway_subnet_prefix]
}


# ============================================================
# Hub-to-Spoke VNet Peering
# ============================================================

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = azurerm_resource_group.hub.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}


# ============================================================
# Spoke-to-Hub VNet Peering
# ============================================================

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub"
  resource_group_name       = azurerm_resource_group.spoke.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = azurerm_virtual_network.hub.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}


# ============================================================
# Spoke Route Table
# ============================================================

resource "azurerm_route_table" "spoke" {
  name                = var.spoke_route_table_name
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name

  tags = merge(
    var.common_tags,
    {
      Component = "Spoke-Routing"
    }
  )
}


# ============================================================
# Default Route Through Azure Firewall
# ============================================================

resource "azurerm_route" "spoke_default_route" {
  name                = "route-default-to-firewall"
  resource_group_name = azurerm_resource_group.spoke.name
  route_table_name    = azurerm_route_table.spoke.name

  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}


# ============================================================
# Associate Route Table with Workload Subnet
# ============================================================

resource "azurerm_subnet_route_table_association" "workload" {
  subnet_id      = azurerm_subnet.workload.id
  route_table_id = azurerm_route_table.spoke.id
}