# 01 - Isolated Storage Account & Private Link Endpoint

## Executive Summary
Implementation of an enterprise-grade, zero-trust storage layer for DmonTech. Public access is fully disabled, forcing all data plane traffic through an Azure Private Endpoint inside the Spoke VNet.

## 1. Configuration Overview
* **Storage Account Name:** `stspokeprod01`
* **Resource Group:** `rg-spoke-prod-01`
* **Performance / Redundancy:** Standard / LRS (Locally-Redundant Storage)
* **Public Network Access:** **Disabled** (Deny all public traffic)

## 2. Private Endpoint Details
* **Private Endpoint Name:** `pe-stspokeprod01-blob`
* **Target Sub-Resource:** `blob`
* **Virtual Network:** `vnet-spoke-prod-01`
* **Subnet:** `snet-spoke-workloads-01`
* **Allocated Private IP:** `10.1.0.X` (Dynamic internal IP)

## 3. DNS Integration
* **Private DNS Zone:** `privatelink.blob.core.windows.net`
* **Record Type:** `A` Record automatically mapping `stspokeprod01.privatelink.blob.core.windows.net` to the Private Endpoint internal IP address.
* **Security Impact:** Prevents data exfiltration and mitigates exposure to internet-facing threats by ensuring data transit occurs exclusively across the Microsoft backbone network.