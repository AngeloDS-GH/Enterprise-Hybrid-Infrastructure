# 📂 Phase 5 — Azure Hybrid Networking (Hub-and-Spoke Topology)

## 📌 Architectural Overview

To support DmonTech's modern cloud adoption strategy, we designed a scalable, highly secure **Hub-and-Spoke Virtual Network architecture** in Azure (East US region), planned for seamless connection to our on-premises infrastructure (`192.168.10.0/24`).

                    [ ON-PREMISES ]
                  (dmontech.local / DC01)
                       192.168.10.0/24
                             │
                 (Site-to-Site VPN Tunnel)
                             │
                             ▼
                 ┌───────────────────────┐
                 │   vnet-hub-eastus-01  │
                 │      10.0.0.0/16      │
                 ├───────────────────────┤
                 │ ├─ GatewaySubnet      │
                 │ └─ AzureFirewallSubnet│
                 └───────────┬───────────┘
                             │
                 (VNet Peering + Routing)
                             │
                             ▼
                ┌─────────────────────────┐
                │ vnet-spoke-prod-eastus  │
                │       10.1.0.0/16       │
                ├─────────────────────────┤
                │ └─ snet-app-prod-01     │
                └─────────────────────────┘

                ## 🧠 Architectural Decisions

| Decision | Selection | Rationale |
| :--- | :--- | :--- |
| **Network Topology** | Hub-and-Spoke | Centralizes management and VPN gateways in the Hub, isolating app workloads in Spokes. |
| **Traffic Inspection** | Azure Firewall | Replaces basic NSG filters with central L7 inspection. |
| **IaC Strategy** | Terraform | Ensures repeatable deployments across environments without manual Portal dependencies. |