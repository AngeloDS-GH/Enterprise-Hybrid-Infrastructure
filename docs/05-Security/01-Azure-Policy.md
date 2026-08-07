# Azure Policy

## Overview

Azure Policy was implemented to enforce organizational governance standards across the DmonTech Azure environment.

The primary objective was to ensure that Azure resources are deployed only within approved regions, reducing operational risk, maintaining compliance, and preventing accidental deployments in unsupported locations.

Azure Policy provides centralized governance by continuously evaluating Azure resources against predefined rules and automatically denying or auditing non-compliant deployments.

---

# Business Requirements

The organization required:

- Standardize resource deployments.
- Restrict Azure resource creation to approved regions.
- Reduce configuration drift.
- Improve governance across Azure subscriptions.
- Support future compliance and auditing initiatives.

---

# Solution Overview

An Azure Policy Assignment was created at the subscription level using the built-in **Allowed locations** policy definition.

Policy Scope

```
Azure Subscription
```

Policy Definition

```
Allowed locations
```

Allowed Region

```
East US 2
```

Effect

```
Deny
```

Applying the policy at the subscription level ensures that every future deployment is evaluated before resource creation.

---

# Policy Assignment

The policy was assigned using Azure Policy's built-in definitions.

Configuration included:

- Subscription Scope
- Built-in Policy Definition
- East US 2 as the only approved deployment region
- Deny effect for non-compliant resources

This approach prevents administrators from accidentally deploying infrastructure outside the organization's approved Azure region.

---

# Validation

The following validations were completed:

- Azure Policy successfully assigned.
- Policy applied at subscription scope.
- Allowed deployment region configured.
- Deny enforcement enabled.

The environment is now governed by centralized deployment restrictions.

---

# Governance Benefits

Using Azure Policy provides several operational advantages:

- Standardized deployments.
- Improved governance.
- Reduced human error.
- Easier regulatory compliance.
- Consistent Azure architecture.
- Better long-term operational management.

---

# Lessons Learned

Azure Policy is one of the foundational governance services within Azure.

Rather than relying on administrative procedures, Azure Policy enforces organizational standards automatically before resources are deployed.

Applying policies at the subscription level simplifies governance and ensures consistent configuration across future Azure resources.

---

# Screenshots

-Azure Policy Allowed Locations configuration
![Azure Policy Allowed Locations configuration](../../images/allowed-locations-policy-overview.png)
