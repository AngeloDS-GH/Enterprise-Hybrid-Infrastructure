# Azure Key Vault

## Overview

Azure Key Vault was implemented to provide centralized and secure storage for sensitive information used throughout the DmonTech hybrid infrastructure.

Instead of embedding passwords, connection strings, certificates, or cryptographic keys within applications or scripts, Azure Key Vault provides a managed service for securely storing and controlling access to secrets.

The implementation follows Microsoft's Zero Trust principles by enforcing Azure Role-Based Access Control (RBAC) instead of the legacy Access Policies model.

---

# Business Requirements

The organization required:

- Secure storage for administrative credentials and application secrets.
- Centralized management of sensitive information.
- Granular access control using Azure RBAC.
- Support for future application integrations.
- Reduce the risk of credential exposure.

---

# Solution Overview

Azure Key Vault was deployed using Azure RBAC as the authorization model.

Resource Name

```
kv-dmontech-prod-01
```

Region

```
East US 2
```

Pricing Tier

```
Standard
```

Authorization Model

```
Azure Role-Based Access Control (RBAC)
```

A sample secret was created to validate permissions and demonstrate secure secret management.

---

# RBAC Configuration

Instead of using Vault Access Policies, Azure RBAC was selected as the authorization model.

To allow secret management, the following Azure role was assigned:

```
Key Vault Secrets Officer
```

This role grants permission to create, update, delete, and manage secrets without providing unnecessary administrative privileges over the entire Azure subscription.

This approach aligns with the Principle of Least Privilege by assigning only the permissions required to perform the intended administrative tasks.

---

# Secret Management

A sample secret was created to validate the deployment.

Secret Name

```
SqlAdminPassword
```

The secret was successfully stored inside Azure Key Vault, demonstrating secure credential management without exposing sensitive information within the infrastructure.

For security reasons, secret values were never displayed or documented.

---

# Validation

The following validations were completed:

- Azure Key Vault successfully deployed.
- Azure RBAC configured as the authorization model.
- RBAC permissions assigned successfully.
- Secret creation validated.
- Secret stored securely within Azure Key Vault.

---

# Security Benefits

Azure Key Vault provides several security advantages:

- Centralized secret management.
- Secure storage for passwords, certificates, and cryptographic keys.
- Azure RBAC integration.
- Least Privilege access control.
- Support for Zero Trust security architecture.
- Reduced credential exposure.

---

# Lessons Learned

Using Azure RBAC instead of traditional Access Policies simplifies permission management by integrating Key Vault with Azure's centralized authorization model.

Separating secret storage from applications improves security, simplifies credential rotation, and reduces the likelihood of accidental credential exposure.

Azure Key Vault is a foundational service for implementing secure cloud architectures and supports future integration with virtual machines, applications, automation accounts, and Azure services.

---

# Screenshots

-Azure Key Vault Overview
![Azure Key Vault Overview](../../images/KeyVault-Overview.png)
-RBAC Role Assignment
![RBAC Role Assignment](../../images/IAM-keyvault-config.png)
-Secret List
![Secret List](../../images/KeyVault-Secrets.png)