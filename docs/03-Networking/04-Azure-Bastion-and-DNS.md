# 02 - Azure Bastion & Private DNS Zones Infrastructure

## Executive Summary
This document outlines the deployment of Azure Bastion for secure management access and Azure Private DNS Zones to enforce private name resolution across the Hub-and-Spoke topology without exposing public IP addresses.

## 1. Architectural Principles
* **Zero Public Exposure:** No workloads in the spoke virtual networks possess public IP addresses.
* **Bastion Host Access:** Administrative RDP/SSH sessions are proxied exclusively over HTTPS (port 443) via Azure Bastion.
* **Private Resolution:** Internal resources resolve services through centralized Private DNS Zones integrated into the Spoke VNets.

## 2. Deployed Resources

### Azure Bastion
* **Resource Name:** `bas-hub-prod-01`
* **Resource Group:** `rg-hub-prod-01`
* **Region:** `East US 2`
* **Subnet:** `AzureBastionSubnet` (`10.0.2.0/26`)
* **SKU:** Developer / Basic (Cost-optimized)

### Private DNS Zones
1. **Internal Domain:** `corp.dmontech.internal`
   * **Linked VNet:** `vnet-hub-prod-01` & `vnet-spoke-prod-01`
   * **Auto-registration:** Enabled for spoke virtual machines.
2. **PaaS Private Link Domain:** `privatelink.blob.core.windows.net`
   * **Linked VNet:** `vnet-spoke-prod-01`
   * **Purpose:** Resolves Storage Account Private Endpoints to internal IP space.
