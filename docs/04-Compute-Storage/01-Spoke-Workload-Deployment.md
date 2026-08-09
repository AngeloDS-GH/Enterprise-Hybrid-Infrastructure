# Spoke Workload Deployment & Compute Availability

## Executive Summary

This document covers the deployment and validation of Azure compute workloads within the DmonTech Spoke VNet.

The implementation evolved from an initial workload used to validate forced tunneling and Azure Bastion connectivity into a broader compute architecture demonstrating Azure Virtual Machines, Availability Zones, Availability Sets, Managed Disks, and Virtual Machine Scale Sets.

The objective was to demonstrate multiple Azure compute availability and scalability models while maintaining workload isolation inside the Spoke network.

---

## 1. Initial Spoke Workload

The original workload was deployed inside the Spoke VNet to validate network routing, centralized traffic inspection, and private administrative access.

### Workload Specifications

| Setting | Value |
|---|---|
| VM Name | `vm-spoke-app-01` |
| Resource Group | `rg-spoke-prod-01` |
| Operating System | Windows Server 2022 Datacenter |
| Public IP | None |
| Region | East US 2 |

The workload was intentionally deployed without a public IP address.

Administrative access was performed through Azure Bastion, while outbound traffic was controlled through the Hub-Spoke networking architecture.

---

## 2. SKU Selection Strategy

During the initial deployment, regional subscription quota restrictions prevented the use of the originally planned B-series virtual machine sizes.

A D-series SKU was therefore selected to complete the workload deployment without requiring a quota increase.

This demonstrated an important operational consideration when designing Azure environments: VM SKU availability can depend on subscription type, regional capacity, and assigned compute quotas.

For production environments, capacity and quota requirements should be reviewed before deployment.

---

## 3. Route Enforcement Validation

The initial workload was also used to validate forced tunneling through the centralized network security architecture.

Effective routes on the VM network interface confirmed that the default route:

```text
0.0.0.0/0
```

used:

```text
Next Hop Type: Virtual Appliance
```

with the Azure Firewall private IP:

```text
10.0.1.4
```

This validated that outbound workload traffic was being redirected toward the centralized Azure Firewall rather than bypassing the Hub security layer.

Azure Bastion was also used to establish an isolated administrative session without assigning a public IP address directly to the workload VM.

---

![vm-spoke-app-01](../../images/compute-vm-overview.png)


# Extended Compute Implementation

## 4. Zoned Workload VM

A second temporary workload was later deployed to demonstrate additional Azure compute capabilities.

### VM Configuration

| Setting | Value |
|---|---|
| VM Name | `vm-spoke-app-02` |
| Resource Group | `rg-spoke-prod-01` |
| Region | East US 2 |
| Availability Zone | Zone 1 |
| Operating System | Windows Server 2022 Datacenter |
| Public IP | None |
| Virtual Network | `vnet-spk-workloads-01` |
| Subnet | `snet-app-01` |
| Private IP | `10.1.1.4` |

The virtual machine was deployed without a public IP address and placed directly inside Availability Zone 1.

Using an Availability Zone demonstrates how workloads can be distributed across physically separated datacenter locations within an Azure region.

### VM Evidence

![vm-spoke-app-02](../../images/vm-spoke-app-02.png)

![Azure VM Availability Zone](../../images/compute-vm-zone-01.png)

*`vm-spoke-app-02` deployed in East US 2*
---

## 5. Azure Managed Disks

A dedicated managed data disk was attached to `vm-spoke-app-02` to demonstrate separation between operating system and application/data storage.

### Data Disk Configuration

| Setting | Value |
|---|---|
| Disk Name | `disk-app-data-01` |
| Disk Type | Azure Managed Disk |
| Storage Type | Standard SSD LRS |
| Size | 32 GiB |
| Host Caching | None |
| Attached VM | `vm-spoke-app-02` |

Using a separate managed data disk allows workload data to be managed independently from the operating system disk.

Azure Managed Disks also abstract the underlying storage account management required for virtual machine disks.

### Managed Disk Evidence

![Azure Managed Data Disk](../../images/vm-data-disk.png)

*Managed data disk `disk-app-data-01` attached to `vm-spoke-app-02` alongside the operating system disk.*

---

## 6. Availability Set

An Availability Set was created to demonstrate the traditional Azure VM high-availability model based on Fault Domains and Update Domains.

### Configuration

| Setting | Value |
|---|---|
| Availability Set | `avset-app-prod-01` |
| Region | East US 2 |
| Fault Domains | 2 |
| Update Domains | 3 |
| Managed Disks | Yes |

The Availability Set was created as a separate availability design demonstration.

`vm-spoke-app-02` was **not** placed inside the Availability Set because the VM was deployed using an Availability Zone. Availability Zones and Availability Sets represent different placement strategies.

### Availability Set Evidence

![Azure Availability Set](../../images/avset-app-prod-01.png)

*`avset-app-prod-01` configured with two Fault Domains, three Update Domains, and Managed Disks.*

---

## 7. Availability Strategy

Two Azure availability models were demonstrated during the project.

### Availability Zones

Availability Zones provide datacenter-level isolation within an Azure region.

The workload:

```text
vm-spoke-app-02
```

was deployed in:

```text
East US 2 - Zone 1
```

This model is appropriate when workloads need protection against failures affecting an individual datacenter location.

### Availability Sets

Availability Sets distribute virtual machines across:

- Fault Domains
- Update Domains

This reduces the probability that multiple workload instances become unavailable simultaneously because of hardware failure or planned platform maintenance.

The project created:

```text
avset-app-prod-01
```

to demonstrate this alternative availability model.

---

## 8. Virtual Machine Scale Set

Azure Virtual Machine Scale Sets were also implemented to demonstrate scalable compute architecture.

### VMSS Configuration

| Setting | Value |
|---|---|
| Scale Set | `vmss-app-prod-01` |
| Resource Group | `rg-spoke-prod-01` |
| Region | East US 2 |
| Orchestration Mode | Flexible |
| Virtual Network | `vnet-spk-workloads-01` |
| Subnet | `snet-app-01` |

The Scale Set was deployed using Flexible orchestration.

Virtual Machine Scale Sets provide a platform for deploying and managing groups of virtual machines while supporting workload scaling and high availability.

For the project, a minimal deployment was used to validate the architecture while controlling Azure consumption.

### VM Scale Set Evidence

![Azure Virtual Machine Scale Set](../../images/vmss-app-prod-01.png)

*`vmss-app-prod-01` deployed using Flexible orchestration within the workload Spoke VNet.*

---

## 9. Compute Architecture

The resulting compute design demonstrates multiple workload deployment strategies:

```text
                     Azure Region
                       East US 2
                           |
          +----------------+----------------+
          |                                 |
          v                                 v
   Availability Zone                 Availability Set
        Zone 1                       avset-app-prod-01
          |                         FD / UD distribution
          v
   vm-spoke-app-02
          |
          +-------------------+
          |                   |
          v                   v
       OS Disk         disk-app-data-01
                      Standard SSD LRS


             Scalable Compute Model
                      |
                      v
             vmss-app-prod-01
                      |
                      v
              Flexible Mode
```

These components demonstrate three different compute design considerations:

- Individual virtual machine deployment.
- High availability.
- Horizontal scalability.

---

## 10. Security Considerations

The compute architecture was designed around workload isolation.

Key security decisions included:

- No public IP assigned to workload VMs.
- Workloads deployed inside the Spoke network.
- Subnet-level protection using Network Security Groups.
- Centralized routing through the Hub architecture.
- Separation of operating system and data disks.
- Private IP addressing for application workloads.

These controls reduce direct Internet exposure and support the broader Zero Trust architecture implemented throughout the project.

---

## 11. Cost Optimization

Compute resources were treated as temporary infrastructure where persistent operation was not required.

The VM Scale Set and other temporary compute resources were removed after their configuration and validation were documented.

`vm-spoke-app-02` was retained temporarily because it was subsequently used to validate:

- Azure Load Balancer.
- Azure Application Gateway.
- Azure Managed Disks.
- Azure Backup.
- Azure VM Restore.

After these tests were completed, the temporary compute infrastructure was removed to prevent unnecessary Azure consumption.

This approach demonstrates lifecycle-aware cloud resource management rather than leaving unused infrastructure provisioned.

---

## 12. Validation Summary

The following Azure Compute capabilities were implemented and validated:

| Capability | Validation |
|---|---|
| Azure Virtual Machine | Completed |
| Private workload deployment | Completed |
| Availability Zone | Completed |
| Managed OS Disk | Completed |
| Managed Data Disk | Completed |
| Availability Set | Completed |
| Fault Domains | Configured |
| Update Domains | Configured |
| Virtual Machine Scale Set | Completed |
| Flexible Orchestration | Configured |
| Forced tunneling | Validated |
| Private administrative access | Validated |

---

## 13. Lessons Learned

Azure provides multiple compute availability models that solve different infrastructure requirements.

Availability Zones provide physical datacenter-level separation, while Availability Sets distribute traditional VM deployments across Fault Domains and Update Domains.

Virtual Machine Scale Sets address a different requirement by providing a scalable compute model capable of managing multiple VM instances.

The implementation also demonstrated that compute architecture cannot be designed independently from networking, security, backup, and cost management. The same workload used during this phase later became the backend target for load-balancing services and the protected workload for Azure Backup.

Finally, subscription quotas and regional SKU availability must be considered during architecture planning because they can directly affect deployment decisions.

---

## Result

The DmonTech Spoke environment successfully demonstrated Azure compute deployment, availability, storage integration, scalability, network isolation, and workload lifecycle management.

The implementation included:

- Private Azure virtual machines.
- Availability Zone placement.
- Availability Set configuration.
- Fault and Update Domains.
- Azure Managed Disks.
- Virtual Machine Scale Sets.
- Forced tunneling through centralized network security.
- Integration with Azure Backup and application delivery services.

Together, these components provide the compute foundation for the DmonTech hybrid Azure architecture.