# 📂 Phase 4 — Endpoint Governance & Automatic Intune Enrollment

## 📌 Architectural Rationale
To align with a Zero Trust security framework, DmonTech requires centralized device management, policy enforcement, and compliance auditing across all endpoints. By leveraging **Hybrid Entra ID Join** combined with **Automatic GPO MDM Enrollment**, devices maintain legacy Active Directory domain trusts for on-premises resource access while registering with **Microsoft Intune** as their primary cloud management authority.

---

## 📐 Architecture & Authentication Flow

[WIN11-CLI01] ──(AD DS)──> [DC01 / dmontech.local] ──(Entra Connect PHS)──> [Entra ID]
│                                                                          │
└─────────────────────(User PRT Token + GPO)───────────────────────────────┘
│
▼
[Microsoft Intune Endpoint]

* **Target Device:** `WIN11-CLI01`
* **Target Identity:** `evargas@dmontech.com` (Synced from `dmontech.local`)
* **Enrollment Mechanism:** Active Directory Group Policy (*User Credential*)
* **Primary Key:** Entra ID Primary Refresh Token (PRT)

---

## 🛠️ Configuration Steps

### 1. Group Policy Configuration (DC01)
* **GPO Name:** `Intune Auto-Enrollment`
* **Path:** `Computer Configuration` -> `Policies` -> `Administrative Templates` -> `Windows Components` -> `MDM`
* **Setting:** `Enable automatic MDM enrollment using default Azure AD credentials`
* **Credential Type:** `User Credential` *(Selected to ensure token compatibility during co-management discovery)*.

### 2. Entra ID Mobility Scope Setup
* **MDM User Scope:** Set to `All`
* **MAM User Scope:** Set to `None` *(Prevents MAM policy interception during native Windows MDM registration)*
* **License Assigned:** Microsoft Intune Plan 1

---

## 🧠 Real-World Engineering & Troubleshooting

### Issue Encountered: SOAP/MDM Protocol Failure (Event IDs 52, 71, 76)
During initial testing, Windows logged the following errors in `DeviceManagement-Enterprise-Diagnostics-Provider/Enrollment`:
* **Event 52:** `Device based token is not supported for enrollment type OnPremiseGroupPolicyCoManaged`
* **Event 76:** `Auto MDM Enroll: Device Credential (0x0), Failed (Mobile Device Management (MDM) is not configured.)`

### Root Cause Analysis
1. **Credential Mismatch:** The client attempted device-based credential authentication (`Device Credential`), which was rejected by Entra ID for the co-management enrollment profile.
2. **Stale Enrollment State:** Cached registry subkeys under `HKLM\SOFTWARE\Microsoft\Enrollments` and old scheduled tasks under `\Microsoft\Windows\EnterpriseMgmt\` caused the client to re-try invalid device tokens.

### Remediation Executed
1. Enforced `User Credential` mode in GPO.
2. Purged stale enrollment registry subkeys and deleted orphaned scheduled tasks via PowerShell.
3. Overrode local registry keys under `HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM` setting `AutoEnrollMDM = 1` and `UseAADCredentialType = 1`.
4. Refreshed the user session (`evargas`) to obtain a clean PRT and trigger immediate registration.

---

## ✅ Verification
* **Local Endpoint:** Executed `dsregcmd /status`. Confirmed `MdmUrl` populated with `https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc`.
* **Intune Admin Center:** Device `WIN11-CLI01` successfully registered under **Devices -> All Devices**, showing status as *Managed by Intune*.
