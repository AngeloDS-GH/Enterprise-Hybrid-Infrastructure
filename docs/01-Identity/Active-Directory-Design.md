# 📂 FASE 1 — Active Directory On-Premises Design (`dmontech.local`)

![Version](https://img.shields.io/badge/version-v0.2--ad-blue)

## 📌 Objective
Establish a reliable, secure on-premises identity foundation for DmonTech's 500 employees across its Costa Rican operations, preparing the environment for future hybrid synchronization with Microsoft Entra ID.

## 📐 Architecture & Configuration
* **Domain Name (FQDN):** `dmontech.local`
* **Primary Domain Controller:** `DC01`
* **IP Address:** `192.168.10.10 /24`
* **DNS Services:** Integrated with AD DS, pointing locally (`127.0.0.1`).

## 🧠 Architectural Decisions 
* **Why a local AD DS first?** Before migrating workloads or identities to the cloud, DmonTech requires a robust local identity source of truth to manage legacy applications, group policies, and local domain-joined endpoints.
* **Why `.local` namespace?** Selected for internal isolated routing, keeping a clear boundary between internal corporate directory services and public-facing DNS records (`dmontech.com`).

---
*Next milestone: Organizational Units (OUs), Users, and GPOs structure.*