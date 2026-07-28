# 📂 Phase 4.1 — Device Compliance, BitLocker Escrow & Cloud LAPS

## 📌 Architectural Rationale
Under a Zero Trust security framework ("Never trust, always verify"), device enrollment alone does not grant access to enterprise assets. DmonTech enforces strict health baselines and local credential management policies pushed via Microsoft Intune to eliminate lateral movement vectors and unencrypted storage risks.

---

## 🛠️ Applied Endpoint Security Policies

### 1. Compliance Requirements Policy
* **Target OS:** Windows 11 (Minimum Build: `10.0.22000`).
* **Enforced Health Controls:**
  * Trusted Platform Module (TPM) 2.0 & Secure Boot required.
  * Code Integrity & Real-time Antivirus active.
  * System Firewall enabled.
  * BitLocker encryption active.
* **Non-Compliance Action:** Mark device non-compliant immediately (blocks access via Conditional Access).

### 2. BitLocker Drive Encryption
* **Cipher Method:** XTS-AES 256-bit across OS, Fixed Data, and Removable Drives.
* **Escrow Target:** Recovery keys backed up directly to Microsoft Entra ID device objects.

### 3. Windows LAPS (Local Administrator Password Solution)
* **Backup Location:** Microsoft Entra ID Cloud Only.
* **Password Expiration:** 30 days.
* **Account Target:** Built-in `Administrator`.
* **Complexity:** Upper/Lower case + Numbers + Special Characters.

---

## 🧪 Validation Results
* **Device:** `WIN11-CLI01`
* **Compliance State:** `Compliant`
* **Check-in Status:** `Succeeded` across all targeted security profiles.