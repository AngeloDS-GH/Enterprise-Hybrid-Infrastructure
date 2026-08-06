# 🔥 Phase 5 — Azure Firewall Deployment

---

# 📌 Business Requirement

As DmonTech migrates workloads to Azure, outbound Internet connectivity must be centrally inspected instead of allowing unrestricted Internet access from every subnet.

Azure Firewall was selected to provide centralized traffic inspection, consistent security policies, and simplified management.

---

# 🎯 Objective

Deploy Azure Firewall Standard inside the Hub Virtual Network and configure centralized outbound traffic filtering.

---

# 🏗️ Firewall Configuration

| Property | Value |
|----------|-------|
| Firewall Name | afw-hub-prod-01 |
| SKU | Standard |
| Region | East US 2 |
| Virtual Network | vnet-hub-prod-01 |

---

# 🌐 Subnet Design

## AzureFirewallSubnet

Address Range:

10.0.1.0/26

Purpose:

Primary data plane responsible for inspecting production traffic.

---

## AzureFirewallManagementSubnet

Address Range:

10.0.1.64/26

Purpose:

Dedicated management interface required by Azure Firewall Standard.

Separating management traffic from data traffic improves operational security and follows Microsoft deployment recommendations.

---

# 🔐 Firewall Policy

Firewall Policy

pol-afw-hub-prod-01

Rule Collection Group

DefaultNetworkRuleCollectionGroup

Rule Collection

rc-outbound-basic

Priority

200

Action

Allow

---

# 📋 Configured Rules

## Rule 1

Name

allow-dns-outbound

Purpose

Allow DNS name resolution.

Source

10.1.0.0/16

Destination

Any

Protocol

UDP

Port

53

---

## Rule 2

Name

allow-web-outbound

Purpose

Allow secure Internet connectivity for production workloads.

Source

10.1.0.0/16

Destination

Any

Protocols

TCP

Ports

80

443

---

# 🧠 Architectural Decisions

Azure Firewall was deployed inside the Hub network to centralize security enforcement across all current and future spoke networks.

This eliminates the need to duplicate security appliances for every business workload and allows consistent policy management.

The Standard SKU was selected because it satisfies the current security requirements while providing a cost-effective solution suitable for the existing project scope.

---

# ✅ Validation

Validated items:

- Firewall deployed successfully
- Private IP assigned (10.0.1.4)
- Firewall Policy associated
- Network Rules active
- Management subnet operational

---

# 📚 Lessons Learned

Azure Firewall requires dedicated infrastructure components such as AzureFirewallSubnet and AzureFirewallManagementSubnet.

Understanding these deployment prerequisites avoids provisioning failures and simplifies future network expansion.