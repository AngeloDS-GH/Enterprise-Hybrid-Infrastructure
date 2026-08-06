# 01 - Spoke Workload Deployment & Route Enforcement

## Executive Summary
Detailed documentation covering the deployment of application workloads within the Spoke VNet (`vnet-spoke-prod-01`), quota bypass strategy, and validation of forced tunneling via User-Defined Routes (UDR).

## 1. Workload Specifications
* **VM Name:** `vm-spoke-app-01`
* **Resource Group:** `rg-spoke-prod-01`
* **Subnet:** `snet-spoke-workloads-01` (`10.1.0.0/24`)
* **SKU:** `Standard_D2als_v7` (2 vCPUs, 4 GiB RAM)
* **Public IP:** **None** (Zero Trust)
* **OS:** Windows Server 2022 Datacenter

## 2. Quota Bypass & SKU Selection Strategy
Due to regional subscription quota restrictions on the B-series family (`Standard_B2s` / `Standard_B1s`) in `East US 2`, the deployment utilized a v7 D-series SKU (`Standard_D2als_v7`) to successfully bypass quota limits without administrative intervention.

## 3. Architectural Validation
* **Effective Routes Verification:** Verified via the Network Interface (`vm-spoke-app-01-nic`) that default outbound traffic (`0.0.0.0/0`) evaluates to `Next Hop Type: VirtualAppliance` pointing to the Central Firewall IP (`10.0.1.4`).
* **Bastion Connection:** Successfully established an isolated administrative session via Azure Bastion over TLS.
