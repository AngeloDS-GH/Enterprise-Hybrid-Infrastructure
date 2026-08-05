# 🌐 Phase 5 — Hub-and-Spoke Network Architecture

---

# 📌 Business Requirement

DmonTech operates four business locations across Costa Rica and is transitioning to a hybrid cloud architecture. The organization requires secure network segmentation while maintaining centralized connectivity and security controls.

A Hub-and-Spoke topology was selected to isolate workloads, simplify network expansion, and centralize shared services such as Azure Firewall, VPN connectivity, and future management services.

---

# 🎯 Objective

Design and implement a scalable Azure Hub-and-Spoke network topology that supports future cloud growth while aligning with Microsoft Azure Well-Architected Framework networking recommendations.

---

# 🏗️ Network Architecture

## Hub Virtual Network

| Property | Value |
|----------|-------|
| Name | vnet-hub-prod-01 |
| Address Space | 10.0.0.0/16 |
| Purpose | Shared Services |

---

## Spoke Virtual Network

| Property | Value |
|----------|-------|
| Name | vnet-spoke-prod-01 |
| Address Space | 10.1.0.0/16 |
| Purpose | Production Workloads |

---

# 🔗 Connectivity

Bidirectional Virtual Network Peering was established between both VNets.

Hub → Spoke

Spoke → Hub

Gateway Transit is reserved for future VPN Gateway implementation.

---

# 🧠 Architectural Decisions

## Why Hub-and-Spoke?

Instead of connecting every workload directly, DmonTech centralizes shared infrastructure inside the Hub network.

Benefits include:

- Centralized security inspection
- Easier network management
- Simplified future branch expansion
- Reduced administrative overhead
- Better workload isolation
- Improved scalability

---

# 🔐 Security Considerations

The Hub network hosts centralized security services while production workloads remain isolated inside Spoke networks.

Traffic between workloads can later be inspected by Azure Firewall before reaching external destinations.

This design aligns with Zero Trust principles by minimizing unnecessary network trust relationships.

---

# ✅ Validation

The following components were successfully validated:

- Hub VNet deployment
- Spoke VNet deployment
- Bidirectional VNet Peering
- Successful routing between networks
- Address space verification

---


# 📚 Lessons Learned

Separating shared infrastructure from application workloads provides better scalability and security than deploying all resources inside a single virtual network.

The Hub-and-Spoke architecture also simplifies future integration of VPN Gateway, Azure Firewall, Bastion, and additional production environments.