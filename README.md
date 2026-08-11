# 🏢 Enterprise Hybrid Infrastructure — DmonTech

## 📌 Project Overview

**DmonTech** is a fictional Costa Rican manufacturing and engineering company with approximately **500 employees across four operational sites**.

The organization relies on traditional on-premises infrastructure and is modernizing its IT environment through the adoption of **Microsoft Azure, Microsoft 365, Microsoft Entra ID, and Microsoft Intune**.

This project simulates the design and implementation of that modernization strategy through a hands-on enterprise infrastructure lab combining:

- Hybrid Identity
- Active Directory
- Microsoft Intune
- Zero Trust security
- Azure Hub-and-Spoke networking
- Secure compute and storage
- Cloud security and SIEM
- Monitoring and alerting
- Backup and disaster recovery
- Cost governance
- PowerShell automation
- Terraform Infrastructure as Code

The environment was **designed, deployed, configured, validated, troubleshot, and documented** throughout this repository.

---

## 🎯 Strategic Objectives

The DmonTech modernization initiative was designed around the following objectives:

- **Hybrid Identity:** Integrate on-premises Active Directory with Microsoft Entra ID.
- **Endpoint Governance:** Manage Windows endpoints through Microsoft Intune, compliance policies, configuration profiles, and security controls.
- **Secure Hybrid Networking:** Implement an Azure Hub-and-Spoke architecture with centralized routing and security inspection.
- **Zero Trust Security:** Apply MFA, Conditional Access, RBAC, endpoint compliance, encryption, network segmentation, and private connectivity.
- **Cloud Infrastructure:** Deploy Azure compute, networking, storage, security, monitoring, and recovery services.
- **Security Monitoring:** Establish centralized security visibility using Microsoft Defender for Cloud and Microsoft Sentinel.
- **Infrastructure as Code:** Represent the core Azure architecture using Terraform.
- **Automation:** Use PowerShell for Active Directory provisioning and endpoint management tasks.
- **Operational Governance:** Implement monitoring, backup validation, cost analysis, and budget controls.

---

## ⭐ Key Technical Achievements

The project includes hands-on implementation and validation of several enterprise infrastructure scenarios:

- Built an on-premises **Active Directory environment with two Domain Controllers**.
- Implemented organizational units, users, groups, DNS, DHCP, GPOs, Sites and Services, and AD replication.
- Integrated on-premises identity with **Microsoft Entra ID**.
- Validated **Hybrid Microsoft Entra Joined** Windows endpoints.
- Implemented **Microsoft Intune automatic MDM enrollment**.
- Applied endpoint compliance and configuration policies.
- Implemented BitLocker, Microsoft Defender Antivirus, and Windows Firewall policies.
- Designed and deployed an **Azure Hub-and-Spoke network architecture**.
- Implemented **Azure Firewall** with centralized outbound routing using UDRs.
- Configured **NSGs** for subnet-level network protection.
- Configured the Azure side of a **Site-to-Site VPN architecture**.
- Implemented **Azure Bastion and Private DNS** architecture.
- Deployed and tested **Azure Load Balancer and Application Gateway**.
- Implemented secure Azure Storage with **Private Endpoint connectivity**.
- Configured **Azure Key Vault using Azure RBAC**.
- Implemented governance using **Azure Policy**.
- Configured **Microsoft Defender for Cloud**.
- Deployed **Microsoft Sentinel** using Log Analytics.
- Implemented Azure Monitor, Activity Log diagnostic settings, alerts, and Workbooks.
- Performed an actual **Azure VM backup and restore test** using Azure Backup.
- Implemented Azure Cost Analysis and monthly budget alerts.
- Represented the core Azure architecture using **Terraform**.
- Created PowerShell automation and troubleshooting scripts for Active Directory and Intune.

---

## 🏗️ Architecture Overview

The project combines an on-premises Windows Server environment with Microsoft cloud services.

```text
                         Microsoft Entra ID
                                │
                         Hybrid Identity
                                │
                                ▼
                  On-Premises Active Directory
                     DC01             DC02
                       │               │
                       └───────┬───────┘
                               │
                               ▼
                        Microsoft Azure
                               │
                  ┌────────────┴────────────┐
                  │                         │
                 HUB                      SPOKE
                  │                         │
          Azure Firewall              Workloads
          VPN Gateway                     │
          Azure Bastion                   ├── Virtual Machines
          Central Routing                 ├── NSGs
                  │                       ├── UDRs
                  │                       ├── Load Balancer
                  │                       ├── Application Gateway
                  │                       │
                  └────── Peering ────────┤
                                          │
                                          ▼
                                   Private Endpoint
                                          │
                                          ▼
                                     Azure Storage
```

The Hub network centralizes shared connectivity and security services, while workload infrastructure remains isolated inside the Spoke network.

---

# 🛠️ Technology Stack

## 🖥️ On-Premises Infrastructure

- Windows Server 2022
- Active Directory Domain Services
- DNS
- DHCP
- Group Policy
- Active Directory Sites and Services
- PowerShell

---

## ☁️ Cloud & Identity

- Microsoft Azure
- Microsoft Entra ID
- Microsoft 365
- Hybrid Identity
- Conditional Access
- Multi-Factor Authentication
- Self-Service Password Reset
- Azure Role-Based Access Control

---

## 📱 Endpoint Management

- Microsoft Intune
- Hybrid Microsoft Entra Join
- Automatic MDM Enrollment
- Compliance Policies
- Configuration Profiles
- BitLocker
- Microsoft Defender Antivirus
- Windows Firewall

---

## 🌐 Azure Networking

- Azure Virtual Networks
- Hub-and-Spoke Networking
- VNet Peering
- Azure Firewall
- Azure Firewall Policy
- User-Defined Routes
- Network Security Groups
- VPN Gateway
- Local Network Gateway
- Site-to-Site VPN configuration
- Azure Bastion
- Private DNS Zones
- Private Endpoints
- Azure Load Balancer
- Azure Application Gateway

---

## 💻 Compute & Storage

- Azure Virtual Machines
- Azure Storage Accounts
- Blob Storage
- Azure Files
- Storage Lifecycle Management
- Private Storage Connectivity

---

## 🔐 Security

- Azure Policy
- Azure Key Vault
- Azure RBAC
- Microsoft Defender for Cloud
- Microsoft Sentinel
- Conditional Access
- MFA
- BitLocker
- Network Security Groups
- Azure Firewall
- Private Endpoints

---

## 📊 Monitoring & Recovery

- Azure Monitor
- Log Analytics Workspace
- Activity Logs
- Diagnostic Settings
- Azure Monitor Alerts
- Azure Workbooks
- Microsoft Sentinel
- Azure Backup
- Recovery Services Vault
- VM Backup and Restore

---

## 💰 Cost Governance

- Azure Cost Management
- Cost Analysis
- Azure Budgets
- Actual-Cost Alerts
- Resource Lifecycle Management

---

## ⚙️ Infrastructure as Code & Automation

- Terraform
- AzureRM Provider
- PowerShell
- Git
- GitHub

---

# 🔐 Zero Trust Security Architecture

The environment applies multiple security layers instead of relying on a single security boundary.

```text
Identity
   │
   ├── Microsoft Entra ID
   ├── MFA
   ├── Conditional Access
   └── RBAC
          │
          ▼
Endpoint
   │
   ├── Microsoft Intune
   ├── Compliance Policies
   ├── BitLocker
   ├── Defender Antivirus
   └── Windows Firewall
          │
          ▼
Network
   │
   ├── Azure Firewall
   ├── NSGs
   ├── UDRs
   ├── VPN Gateway
   └── Private Endpoints
          │
          ▼
Data
   │
   ├── Secure Storage
   ├── Azure Key Vault
   └── Private Connectivity
          │
          ▼
Operations
   │
   ├── Defender for Cloud
   ├── Microsoft Sentinel
   ├── Azure Monitor
   ├── Backup & Recovery
   └── Cost Governance
```

This architecture applies security controls across **identity, endpoints, networking, data, and operations**.

---

# 🌐 Azure Networking Architecture

A Hub-and-Spoke topology was implemented to separate shared infrastructure from production workloads.

The Hub network provides centralized services including:

- Azure Firewall
- VPN Gateway
- Azure Bastion
- Centralized routing

The Spoke environment contains production workloads and application delivery infrastructure.

Traffic flow can be controlled through:

```text
Spoke Workload
      │
      ▼
     UDR
      │
      ▼
Azure Firewall
      │
      ▼
External Destination
```

This architecture provides centralized security enforcement while maintaining workload isolation.

---

# 💾 Backup & Recovery Validation

Azure Backup was implemented using a **Recovery Services Vault**.

The project went beyond simply configuring backup protection.

An on-demand backup was executed for an Azure Virtual Machine, a recovery point was generated, and an actual restore operation was performed using:

```text
Replace Existing
```

The complete workflow was validated:

```text
Configure Backup
      │
      ▼
Backup
      │
      ▼
Recovery Point
      │
      ▼
Restore
      │
      ▼
Completed
```

This demonstrates **actual workload recoverability rather than backup configuration alone**.

---

# 🛡️ Security Monitoring

Microsoft security services were integrated to establish centralized security visibility.

The monitoring architecture includes:

```text
Azure Resources
      │
      ▼
Activity Logs
      │
      ▼
Log Analytics Workspace
      │
      ├────────► Azure Monitor
      │
      └────────► Microsoft Sentinel
                       │
                       ▼
                Security Analysis
```

Microsoft Defender for Cloud provides cloud security posture management, while Microsoft Sentinel establishes the foundation for centralized SIEM capabilities.

---

# 💰 Cost Governance

Azure Cost Management was incorporated into the project as part of the infrastructure lifecycle.

Cost Analysis was used to identify consumption by Azure service.

A monthly budget of:

```text
$50 USD
```

was configured with actual-cost notification thresholds at:

```text
80%  → $40
100% → $50
```

High-cost resources were deployed when required for implementation and validation and removed when they were no longer necessary.

Examples included:

- Azure Firewall
- Azure Bastion
- VPN Gateway
- Application Gateway
- Load Balancer
- Virtual Machine Scale Set
- Temporary compute resources
- Recovery infrastructure after validation

This allowed enterprise Azure services to be demonstrated while maintaining control over laboratory cloud consumption.

---

# ⚙️ Infrastructure as Code

The core Azure architecture was translated into **Terraform**.

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

Terraform implementation is available in:

```text
/terraform
```

---

# 🤖 PowerShell Automation

PowerShell was used for infrastructure provisioning and endpoint troubleshooting.

The repository includes:

### `01_Build_AD_Structure.ps1`

Automates initial Active Directory provisioning, including:

- Organizational Units
- Site-based OUs
- Security Groups
- Sample Users
- Hybrid identity UPN suffix preparation

### `02_Cleanup_Intune_Enrollment.ps1`

Provides endpoint-side Intune enrollment troubleshooting by cleaning stale MDM enrollment artifacts.

### `03_Force_MDM_UserCredential.ps1`

Configures Windows automatic MDM enrollment settings using Microsoft Entra user credentials and validates the resulting configuration.

PowerShell implementation is available in:

```text
/powershell
```

---

# 📂 Repository Structure

```text
Enterprise-Hybrid-Infrastructure/
│
├── docs/
│   ├── 01-Active-Directory/
│   ├── 02-Intune/
│   ├── 03-Networking/
│   ├── 04-Compute-Storage/
│   ├── 05-Security/
│   ├── 06-Monitoring-Backup/
│   └── 07-Cost-Analysis/
│
├── diagrams/       # Architecture diagrams
├── images/         # Deployment evidence and screenshots
├── powershell/     # PowerShell automation and troubleshooting
├── terraform/      # Infrastructure as Code
│
├── .gitignore
└── README.md
```

Detailed implementation procedures, architectural decisions, validation results, lessons learned, and deployment evidence are available inside the **`/docs`** directory.

---

# 🗺️ Project Roadmap

| Phase | Implementation | Status |
|---|---|---|
| Phase 0 | Planning & Architecture | ✅ Completed |
| Phase 1 | Active Directory Infrastructure | ✅ Completed |
| Phase 2 | Microsoft 365 & Entra ID | ✅ Completed |
| Phase 3 | Hybrid Identity & Zero Trust | ✅ Completed |
| Phase 4 | Microsoft Intune | ✅ Completed |
| Phase 5 | Azure Networking | ✅ Completed |
| Phase 6 | Azure Compute & Storage | ✅ Completed |
| Phase 7 | Azure Security | ✅ Completed |
| Phase 8 | Monitoring & SIEM | ✅ Completed |
| Phase 9 | Backup & Recovery | ✅ Completed |
| Phase 10 | Cost Management | ✅ Completed |
| Phase 11 | PowerShell Automation | ✅ Completed |
| Phase 12 | Terraform Infrastructure as Code | ✅ Completed |

---

# ✅ Project Status

## Core Infrastructure Implementation: **Completed**

The project currently demonstrates:

- [x] Active Directory Domain Services
- [x] Multi-DC architecture
- [x] DNS and DHCP
- [x] Group Policy
- [x] AD Sites and Services
- [x] Hybrid identity
- [x] Microsoft Entra ID
- [x] Microsoft Intune
- [x] Hybrid Microsoft Entra Join
- [x] Automatic MDM Enrollment
- [x] Endpoint compliance
- [x] BitLocker policies
- [x] Defender Antivirus policies
- [x] Windows Firewall policies
- [x] Conditional Access and MFA
- [x] Azure Hub-and-Spoke networking
- [x] Azure Firewall
- [x] User-Defined Routes
- [x] Network Security Groups
- [x] VPN infrastructure
- [x] Azure Bastion
- [x] Private DNS
- [x] Azure Load Balancer
- [x] Azure Application Gateway
- [x] Azure compute workloads
- [x] Secure Azure Storage
- [x] Private Endpoint connectivity
- [x] Azure Policy
- [x] Azure Key Vault
- [x] Microsoft Defender for Cloud
- [x] Microsoft Sentinel
- [x] Azure Monitor
- [x] Log Analytics
- [x] Azure Backup
- [x] Successful VM restore validation
- [x] Azure Cost Management
- [x] Azure Budget alerts
- [x] PowerShell automation
- [x] Terraform Infrastructure as Code

---

# 🚀 Future Improvements

Potential future extensions include:

- Terraform remote state using Azure Storage.
- CI/CD pipeline for Terraform validation and deployment.
- Expanded Log Analytics queries and dashboards.
- Advanced Microsoft Sentinel analytics rules.
- Sentinel automation and Playbooks.
- Linux workloads.
- Containerized applications.
- Advanced Azure Firewall policies.
- Automated infrastructure testing.
- Additional PowerShell automation.
- Azure Monitor alert automation.
- Expanded disaster recovery testing.
- Standardized resource tagging and cost allocation.
- Multi-environment Terraform architecture for development, testing, and production.

---

# 👤 Author

**Angelo Solano**

**Microsoft Certified: Azure Administrator Associate (AZ-104)**

Cloud Infrastructure | Microsoft Azure | Microsoft Intune | Microsoft Entra ID | Active Directory | Terraform | PowerShell

---

*Designed, implemented, validated, troubleshot, and documented as a hands-on enterprise infrastructure project aligned with Microsoft Azure administration, hybrid cloud, security, and architecture practices.*