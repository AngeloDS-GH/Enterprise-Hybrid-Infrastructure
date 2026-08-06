# 🛣️ Phase 5 — User Defined Routes (UDR)

---

# 📌 Business Requirement

To enforce centralized security inspection, production workloads must not access the Internet directly.

Instead, all outbound traffic should be redirected through Azure Firewall before leaving the Azure environment.

---

# 🎯 Objective

Configure User Defined Routes (UDRs) that force outbound traffic from the Spoke Virtual Network to Azure Firewall.

---

# 🏗️ Route Table

| Property | Value |
|----------|-------|
| Name | rt-spoke-to-hub-01 |
| Associated Subnet | Spoke Application Subnet |

---

# 📋 Configured Route

Destination Prefix

0.0.0.0/0

Next Hop Type

Virtual Appliance

Next Hop Address

10.0.1.4

---

# 🔐 Security Rationale

Without User Defined Routes, Azure workloads can communicate directly with the Internet using Azure's default routing behavior.

By overriding the default system route, every outbound connection is inspected by Azure Firewall before reaching external destinations.

This approach supports:

- Centralized monitoring
- Traffic inspection
- Future logging
- Security policy enforcement
- Zero Trust networking

---

# 🧠 Architectural Decisions

A forced tunneling model was selected because it provides a single point for network policy enforcement and reduces the attack surface exposed by direct Internet access.

As new spoke networks are deployed, they can reuse the same routing strategy without redesigning the network architecture.

---

# ✅ Validation

Validated items:

- Route Table deployed
- Route associated with Spoke subnet
- Next Hop resolved to Azure Firewall
- Effective Routes confirmed
- Traffic successfully redirected

---

# 📚 Lessons Learned

User Defined Routes are fundamental in Hub-and-Spoke environments because Azure system routes alone cannot enforce centralized security inspection.

Combining UDRs with Azure Firewall provides a scalable network security architecture that aligns with Zero Trust principles.