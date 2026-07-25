# ☁️ Phase 2 & 3 — Hybrid Identity & SSPR Password Writeback

## 📌 Business & Technical Rationale
To enable single-identity lifecycle management across **DmonTech**'s on-premises Active Directory (`dmontech.local`) and cloud ecosystem, we deployed **Microsoft Entra Connect V2**. This establishes an enterprise Zero Trust identity boundary while minimizing IT Helpdesk overhead via cloud-driven credential management.

---

## 🏗️ Architecture & Sync Strategy

* **Synchronization Engine:** Microsoft Entra Connect V2 (Installed on `DC01`).
* **Authentication Method:** Password Hash Synchronization (PHS) using HMAC-SHA256 (1000 iterations).
* **UPN Suffix Alignment:** Configured `@dmontech.com` UPN suffix across local users to match the primary Azure tenant identity domain.
* **Granular Scope (OU Filtering):** Restricted sync scope exclusively to `OU=DmonTech,DC=dmontech,DC=local` to prevent unvetted administrative or legacy service accounts from entering the cloud identity boundary.

---

## 🔐 Hybrid SSPR & Password Writeback Implementation

* **Tenant Licensing:** Microsoft Entra ID P2 Trial.
* **Writeback Protocol:** Enabled bi-directional credential flow on Entra Connect Sync engine and activated global Self-Service Password Reset (SSPR) policies in Microsoft Entra Admin Center.
* **Account Recovery:** Enabled account unlocking directly from the cloud SSPR portal without requiring password modification.

---

## 🧪 Validation & Audit Logs

1. **Cloud Provisioning:** Verified user accounts (`cmora`, `evargas`, `achaves`, `scastro`) successfully provisioned with `On-premises sync enabled: Yes`.
2. **Bi-Directional SSPR Validation:** Initiated SSPR credential reset from the cloud portal (`passwordreset.microsoftonline.com`).
3. **On-Premises Event Audit:** Confirmed real-time password writeback on `DC01` Security Log:
   * **Event ID:** `4723` (*An attempt was made to change an account's password*).
   * **Result:** Local domain Kerberos/NTLM hashes updated in real time from cloud trigger.