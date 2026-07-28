# 🏢 Enterprise Hybrid Infrastructure — DmonTech

![Project Version](https://img.shields.io/badge/version-v0.5--Azure-blue)
![Architecture](https://img.shields.io/badge/Architecture-Hybrid--Cloud-orange)
![Security](https://img.shields.io/badge/Model-Zero%20Trust-green)

## 📌 Project Overview
**DmonTech** is a Costa Rican manufacturing and engineering company with 500 employees across 4 operational sites. Currently relying on legacy on-premises infrastructure, DmonTech is modernizing its IT operations by migrating to Microsoft Azure and Microsoft 365, adopting a **Zero Trust** security framework, and implementing a **Hub-and-Spoke** network topology.

## 🎯 Strategic Objectives
* **Hybrid Identity:** Integrate Active Directory Domain Services (AD DS) with Microsoft Entra ID.
* **Device Governance:** Manage 100% of enterprise endpoints using Microsoft Intune and Windows Autopilot.
* **Secure Hybrid Network:** Design a Hub-and-Spoke topology in Azure featuring central traffic inspection via Azure Firewall.
* **Zero Trust & Security:** Implement Conditional Access, PIM, BitLocker, and multi-layer workload protection.
* **Infrastructure as Code (IaC):** Provision key cloud resources using Terraform and Bicep.

## 🛠️ Tech Stack
* **On-Premises:** Windows Server (AD DS, DNS, DHCP, GPOs).
* **Cloud & Identity:** Microsoft Entra ID, Entra Cloud Sync, PIM, SSPR, RBAC.
* **Endpoint Management:** Microsoft Intune, Defender for Endpoint, Windows Autopilot, LAPS.
* **Azure Infrastructure:** VNets, Hub-and-Spoke, Azure Firewall, Bastion, VPN Gateway, Key Vault.
* **IaC & Automation:** Terraform, Bicep, PowerShell, Microsoft Graph API.

## 🗺️ Version Roadmap
- [x] **v0.1:** PHASE 0 — Planning, corporate profile, and repository framework setup.
- [x] **v0.2:** PHASE 1 — On-Premises Active Directory Infrastructure.
- [x] **v0.3:** PHASE 2 & 3 — Cloud Identity (Entra ID, Hybrid Sync & Zero Trust).
- [x] **v0.4:** PHASE 4 — Endpoint Governance & Automatic Intune Enrollment.
- [ ] **v0.5:** PHASE 5, 6 & 7 — Azure Networking, Compute & Storage.
- [ ] **v0.6:** PHASE 8, 9 & 10 — Advanced Security, Monitoring, and Backup.
- [ ] **v1.0:** PHASE 11 & 12 — Automation (IaC) and Cost Optimization (AZ-305 Ready).

---
*Designed and documented as a hands-on project aligned with the Microsoft Azure Solutions Architect Expert (AZ-305) exam objectives.*