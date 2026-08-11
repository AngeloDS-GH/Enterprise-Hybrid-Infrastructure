# 🏢 Enterprise Hybrid Infrastructure — DmonTech

## 📌 Project Overview

**DmonTech** is a Costa Rican manufacturing and engineering company with approximately 500 employees across 4 operational sites.

The organization currently relies on traditional on-premises infrastructure and is modernizing its IT environment through the adoption of **Microsoft Azure, Microsoft 365, Microsoft Entra ID, and Microsoft Intune**.

This project simulates the design and implementation of that modernization strategy, combining **Hybrid Identity, Zero Trust security, Hub-and-Spoke networking, endpoint management, Azure infrastructure, monitoring, backup, cost governance, and Infrastructure as Code (IaC).**

The environment was implemented as a hands-on enterprise lab and documented throughout this repository.

---

## 🎯 Strategic Objectives

- **Hybrid Identity:** Integrate Active Directory Domain Services (AD DS) with Microsoft Entra ID using Entra Cloud Sync.
- **Device Governance:** Manage enterprise endpoints using Microsoft Intune, compliance policies, and Windows Autopilot.
- **Secure Hybrid Network:** Implement an Azure Hub-and-Spoke architecture with centralized traffic inspection through Azure Firewall.
- **Zero Trust Security:** Apply Conditional Access, MFA, RBAC, BitLocker, Defender, NSGs, and private connectivity.
- **Cloud Infrastructure:** Deploy secure Azure compute, networking, storage, monitoring, and recovery services.
- **Infrastructure as Code:** Represent the core Azure architecture using Terraform.
- **Operational Governance:** Implement Azure monitoring, backup validation, cost tracking, and budget controls.

---

## 🏗️ Architecture

The project combines an on-premises Windows Server environment with Microsoft cloud services.

```text
                    Microsoft Entra ID
                           │
                    Entra Cloud Sync
                           │
                           ▼
              On-Premises Active Directory
                 DC01             DC02
                   │               │
                   └───────┬───────┘
                           │
                    Hybrid Identity
                           │
                           ▼
                    Microsoft Azure
                           │
                ┌──────────┴──────────┐
                │                     │
               HUB                  SPOKE
                │                     │
         Azure Firewall         Workload Subnet
         VPN Gateway                  │
         Central Routing             ├── Virtual Machine
                │                    ├── NSG
                └──── Peering ───────┼── UDR
                                     └── Private Endpoint
                                              │
                                              ▼
                                         Azure Storage
```

---

## 🛠️ Tech Stack

### On-Premises Infrastructure

- Windows Server 2022
- Active Directory Domain Services
- DNS
- DHCP
- Group Policy
- Active Directory Sites and Services

### Cloud & Identity

- Microsoft Azure
- Microsoft Entra ID
- Microsoft Entra Cloud Sync
- Microsoft 365
- Conditional Access
- MFA
- SSPR
- RBAC

### Endpoint Management

- Microsoft Intune
- Windows Autopilot
- Compliance Policies
- Configuration Profiles
- BitLocker
- Microsoft Defender
- Windows Firewall

### Azure Infrastructure

- Azure Virtual Networks
- Hub-and-Spoke Networking
- VNet Peering
- Azure Firewall
- Firewall Policy
- VPN Gateway
- Azure Bastion
- Network Security Groups
- User-Defined Routes
- Azure Virtual Machines
- Azure Storage
- Azure Files
- Blob Storage
- Private Endpoints
- Private DNS
- Azure Key Vault
- Azure Policy
- Microsoft Defender for Cloud
- Azure Monitor
- Azure Backup
- Recovery Services Vault
- Azure Cost Management

### IaC & Automation

- Terraform
- AzureRM Provider
- PowerShell
- Git
- GitHub

---

## 🔐 Security Architecture

The environment applies multiple security layers following Zero Trust principles:

```text
Identity
   │
   ├── MFA
   ├── Conditional Access
   └── Entra ID
          │
          ▼
Endpoint
   │
   ├── Intune
   ├── Compliance
   ├── BitLocker
   └── Defender
          │
          ▼
Network
   │
   ├── Azure Firewall
   ├── NSGs
   ├── UDRs
   └── Private Endpoints
          │
          ▼
Data & Operations
   │
   ├── Secure Storage
   ├── Backup & Recovery
   ├── Monitoring
   └── Cost Governance
```

---

## 💾 Backup & Recovery Validation

Azure Backup was implemented using a **Recovery Services Vault**.

The project included an actual recovery test in which a protected Azure Virtual Machine was restored using a recovery point and the existing VM disks were successfully replaced.

This validates both backup configuration and workload recoverability.

---

## 💰 Cost Governance

Azure Cost Management was used to analyze infrastructure spending and identify high-cost services.

A monthly budget was configured with notification thresholds to provide proactive cost visibility.

High-cost lab resources such as Azure Firewall, Bastion, VPN Gateway, and Virtual Machines were managed according to lab requirements to minimize unnecessary consumption.

---

## ⚙️ Infrastructure as Code

The core Azure architecture was translated into Terraform.

Terraform configuration includes:

- Resource Groups
- Hub and Spoke VNets
- Subnets
- VNet Peering
- Route Tables
- User-Defined Routes
- Network Security Groups
- Azure Firewall
- Firewall Policy
- Secure Azure Storage
- Azure Files
- Blob Containers
- Private Endpoint
- Private DNS
- Storage Lifecycle Management

The Terraform configuration was formatted, initialized, and successfully validated using:

```powershell
terraform fmt
terraform init
terraform validate
```

Validation result:

```text
Success! The configuration is valid.
```

Terraform implementation:

```text
/terraform
```

---

## 📂 Repository Structure

```text
Enterprise-Hybrid-Infrastructure/
│
├── docs/          # Technical implementation documentation
├── diagrams/      # Architecture diagrams
├── images/        # Deployment evidence and screenshots
├── powershell/    # PowerShell automation
├── scripts/       # Supporting scripts
├── terraform/     # Infrastructure as Code
│
├── .gitignore
└── README.md
```

Detailed implementation evidence and technical explanations are available inside the **`/docs`** directory.

---

## 🗺️ Version Roadmap

- **v0.1:** PHASE 0 — Planning, corporate profile, and repository framework.
- **v0.2:** PHASE 1 — On-Premises Active Directory Infrastructure.
- **v0.3:** PHASE 2 & 3 — Microsoft 365, Entra ID, Hybrid Identity & Zero Trust.
- **v0.4:** PHASE 4 — Endpoint Governance & Microsoft Intune.
- **v0.5:** PHASE 5, 6 & 7 — Azure Networking, Compute & Storage.
- **v0.6:** PHASE 8, 9 & 10 — Security, Monitoring, Backup & Recovery.
- **v1.0:** PHASE 11 & 12 — Terraform Infrastructure as Code & Cost Optimization. ✅

---

## ✅ Project Status

**Core Infrastructure Implementation: Completed**

The project currently demonstrates:

- Hybrid Active Directory and Entra ID integration
- Microsoft Intune endpoint governance
- Zero Trust access controls
- Azure Hub-and-Spoke architecture
- Centralized network security
- Secure compute and storage
- Private connectivity
- Monitoring and governance
- Backup and successful recovery validation
- Cost management
- Terraform Infrastructure as Code

---

## 🚀 Future Improvements

Potential future extensions include:

- Terraform remote state
- CI/CD pipeline for infrastructure deployment
- Expanded Log Analytics and Azure Monitor integration
- Linux workloads
- Containerized applications
- Advanced Azure Firewall policies
- Automated infrastructure testing
- Additional PowerShell automation

---

## 👤 Author

**Angelo Solano**

Microsoft Certified: Azure Administrator Associate (AZ-104)

Cloud Infrastructure | Microsoft Azure | Microsoft Intune | Microsoft Entra ID | Active Directory | Terraform

---

*Designed, implemented, validated, and documented as a hands-on enterprise infrastructure project aligned with Microsoft Azure administration and architecture practices.*