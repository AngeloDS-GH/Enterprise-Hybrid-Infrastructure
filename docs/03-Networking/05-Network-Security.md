# 🛡️ Phase 5 — Network Security and Hybrid Connectivity

---

# 📌 Business Requirement

As DmonTech expands its Azure infrastructure, production workloads require network-level protection and a secure foundation for future connectivity with the on-premises environment.

The organization requires subnet-level traffic filtering, controlled administrative access, and the ability to establish encrypted Site-to-Site connectivity between Azure and the corporate network.

---

# 🎯 Objective

Implement layered network security within the Hub-and-Spoke architecture by combining Network Security Groups (NSGs) with Azure VPN Gateway infrastructure.

The solution was designed to:

- Restrict unnecessary inbound traffic to production workloads.
- Allow administrative access exclusively through Azure Bastion.
- Permit required application traffic within the virtual network.
- Prepare the Hub network for Site-to-Site VPN connectivity.
- Maintain centralized network security while enforcing subnet-level controls.

---

# 🔐 Network Security Group

A Network Security Group was deployed to protect the production workload subnet.

| Property | Value |
|---|---|
| NSG Name | `nsg-spoke-workloads-01` |
| Resource Group | `rg-spoke-prod-01` |
| Region | East US 2 |
| Associated Subnet | `snet-app-01` |
| Virtual Network | `vnet-spk-workloads-01` |
| Custom Inbound Rules | 3 |

The NSG is associated directly with the workload subnet, allowing its security rules to apply to resources deployed within that subnet.

---

# 📋 Inbound Security Rules

The following custom inbound rules were configured:

| Priority | Rule | Protocol | Port | Source | Action |
|---:|---|---|---:|---|---|
| 100 | `Allow-RDP-From-Bastion` | TCP | 3389 | `10.0.2.0/26` | Allow |
| 110 | `Allow-HTTP-VNet` | TCP | 80 | `VirtualNetwork` | Allow |
| 120 | `Allow-HTTPS-VNet` | TCP | 443 | `VirtualNetwork` | Allow |

The RDP rule restricts administrative connectivity to the Azure Bastion subnet instead of permitting RDP directly from the Internet.

HTTP and HTTPS traffic are permitted from resources within the virtual network boundary for application communication.

All other inbound traffic is subject to the default NSG rules, including `DenyAllInBound`.

---

# 🔒 Administrative Access Design

Administrative RDP access follows the following path:

```text
Administrator
      |
      | HTTPS :443
      v
Azure Bastion
bas-hub-prod-01
      |
      | RDP :3389
      v
AzureBastionSubnet
10.0.2.0/26
      |
      v
nsg-spoke-workloads-01
      |
      v
snet-app-01
      |
      v
Production Workloads
```

This prevents direct RDP exposure of workload virtual machines to the public Internet.

---

# 📸 Network Security Group Evidence

![Network Security Group](../../images/nsg-overview-01.png)

*Network Security Group `nsg-spoke-workloads-01` protecting the production workload subnet with dedicated rules for Azure Bastion administrative access and internal HTTP/HTTPS communication.*

---

# 🌐 Azure VPN Gateway

Azure VPN Gateway was deployed in the Hub Virtual Network to provide the Azure side of the future Site-to-Site VPN architecture.

| Property | Value |
|---|---|
| Virtual Network Gateway | `vng-hub-prod-01` |
| Resource Group | `rg-dmontech-net-prod-01` |
| Region | East US 2 |
| SKU | `VpnGw1AZ` |
| Gateway Type | VPN |
| VPN Type | Route-based |
| Virtual Network | `vnet-hub-prod-01` |
| Public IP Resource | `pip-vng-hub-prod-01` |

Deploying the VPN Gateway in the Hub follows the centralized connectivity model of the Hub-and-Spoke architecture.

Future spoke networks can use the Hub as the central connectivity point rather than requiring independent VPN gateways.

---

# 📸 VPN Gateway Evidence

![Azure VPN Gateway](../../images/vng-hub-prod-01-overview.png)

*Azure VPN Gateway `vng-hub-prod-01` deployed in the Hub Virtual Network using the route-based `VpnGw1AZ` SKU.*

---

# 🏢 Local Network Gateway

A Local Network Gateway was created to logically represent the on-premises network from Azure.

| Property | Value |
|---|---|
| Local Network Gateway | `lng-onprem-01` |
| Resource Group | `rg-dmontech-net-prod-01` |
| Region | East US 2 |
| On-Premises Address Space | `192.168.10.0/24` |
| Simulated VPN Endpoint | `203.0.113.10` |

The Local Network Gateway represents the remote side of the Site-to-Site VPN configuration.

Because this project is a cloud laboratory environment, the remote VPN endpoint is simulated and no physical on-premises VPN appliance was deployed.

---

# 📸 Local Network Gateway Evidence

![Local Network Gateway](../../images/local-network-gateway01-overview.png)

*Local Network Gateway `lng-onprem-01` representing the simulated DmonTech on-premises network `192.168.10.0/24`.*

---

# 🔗 Site-to-Site VPN Connection

A Site-to-Site VPN connection was configured between the Azure Virtual Network Gateway and the Local Network Gateway.

| Property | Value |
|---|---|
| Connection | `conn-hub-onprem-01` |
| Virtual Network Gateway | `vng-hub-prod-01` |
| Local Network Gateway | `lng-onprem-01` |
| Azure Network | `vnet-hub-prod-01` |
| Remote Network | `192.168.10.0/24` |
| Connection Type | Site-to-Site (IPsec) |

The resulting architecture is:

```text
Simulated On-Premises Network
192.168.10.0/24
        |
        |
lng-onprem-01
        |
        | IPsec / Site-to-Site VPN
        |
vng-hub-prod-01
        |
        v
vnet-hub-prod-01
        |
        | VNet Peering
        |
        v
vnet-spk-workloads-01
        |
        v
Production Workloads
```

---

# ⚠️ Lab Connection State

The Azure-side Site-to-Site VPN infrastructure was successfully provisioned and configured.

However, a real VPN tunnel was not established because the laboratory does not contain a physical or software-based on-premises VPN device corresponding to the simulated remote endpoint.

As a result, the connection showed no active tunnel traffic.

This behavior is expected and does not represent a deployment failure.

The implementation demonstrates the Azure configuration required to establish hybrid connectivity once a compatible on-premises VPN device is available.

---

# 📸 Site-to-Site VPN Evidence

![Site-to-Site VPN Connection](../../images/site-to-site-vpn-connection.png)

*Site-to-Site connection `conn-hub-onprem-01` linking the Azure VPN Gateway with the simulated Local Network Gateway. No tunnel traffic is expected because no physical on-premises VPN appliance exists in the lab.*

---

# 🧠 Architectural Decisions

## Layered Network Security

The environment does not rely on a single security control.

Instead, different Azure networking services provide protection at different layers:

```text
Azure Firewall
      |
      | Centralized traffic inspection
      v
Route Tables
      |
      | Traffic path enforcement
      v
Network Security Groups
      |
      | Subnet-level filtering
      v
Production Workloads
```

Azure Firewall provides centralized network inspection, while NSGs enforce granular controls directly at the workload subnet.

---

## Bastion-Only Administrative Access

Direct Internet-based RDP access was not permitted.

The NSG allows TCP/3389 from `10.0.2.0/26`, corresponding to the dedicated Azure Bastion subnet.

This allows administrators to manage workloads through Azure Bastion while reducing exposure to Internet-based attacks against administrative ports.

---

## Centralized Hybrid Connectivity

The VPN Gateway was deployed in the Hub rather than inside the workload Spoke.

This allows the Hub to operate as the central connectivity layer for current and future Spoke networks.

The architecture can therefore expand without deploying a separate VPN Gateway for every workload network.

---

# 🛡️ Defense-in-Depth Architecture

The networking environment implements multiple complementary security controls:

| Layer | Azure Service | Purpose |
|---|---|---|
| Central Inspection | Azure Firewall | Inspect centralized network traffic |
| Routing Enforcement | Route Tables | Redirect workload traffic through the firewall |
| Subnet Security | Network Security Groups | Control inbound and outbound subnet traffic |
| Administrative Access | Azure Bastion | Provide secure VM administration without direct public exposure |
| Hybrid Connectivity | Azure VPN Gateway | Provide encrypted connectivity with external networks |

This design reduces unnecessary network exposure while maintaining centralized control over the Azure environment.

---

# ✅ Validation

The following components were successfully validated:

- Network Security Group deployed.
- NSG associated with `snet-app-01`.
- Three custom inbound security rules configured.
- RDP restricted to `AzureBastionSubnet`.
- HTTP and HTTPS internal connectivity rules configured.
- Azure VPN Gateway provisioned.
- Route-based VPN configuration implemented.
- `VpnGw1AZ` SKU deployed.
- Local Network Gateway created.
- Simulated on-premises network defined as `192.168.10.0/24`.
- Site-to-Site VPN connection created.
- Azure-side hybrid connectivity architecture successfully configured.

The VPN tunnel itself was intentionally not validated because no real on-premises VPN endpoint exists in the laboratory environment.

---

# 💰 Cost Management

Azure VPN Gateway is a billable resource even when no active VPN tunnel is transmitting traffic.

Because the purpose of the project was to demonstrate architecture, deployment, and configuration rather than maintain permanent production connectivity, the VPN infrastructure could be removed after validation and documentation.

This follows the laboratory resource lifecycle used throughout the project:

```text
Design
   |
   v
Deploy
   |
   v
Configure
   |
   v
Validate
   |
   v
Document
   |
   v
Remove Temporary Resource
```

This approach demonstrates enterprise Azure networking capabilities while controlling unnecessary laboratory costs.

---

# 📚 Lessons Learned

Network Security Groups and Azure Firewall provide complementary security capabilities rather than replacing each other.

Azure Firewall provides centralized inspection and policy enforcement, while NSGs provide granular subnet-level filtering close to individual workloads.

Restricting RDP access to the Azure Bastion subnet provides a more secure administrative model than exposing management ports directly to the Internet.

Azure VPN Gateway also demonstrates how hybrid connectivity can be centralized through the Hub network. Even without a physical on-premises VPN appliance, deploying the Azure-side components provides practical experience with Virtual Network Gateways, Local Network Gateways, and Site-to-Site VPN connections.

Finally, hybrid network design requires considering routing, security, connectivity, and cost as parts of the same architecture rather than treating them as independent components.

---

# 🏁 Result

The DmonTech Azure networking environment was extended with subnet-level security and hybrid connectivity capabilities.

The implementation included:

- Network Security Group protection for production workloads.
- Restricted RDP connectivity through Azure Bastion.
- Internal HTTP and HTTPS access rules.
- Azure VPN Gateway deployed in the Hub.
- Route-based VPN architecture.
- Local Network Gateway representing the on-premises environment.
- Site-to-Site VPN connection configuration.
- Integration with the existing Hub-and-Spoke architecture.

Together with Azure Firewall, User Defined Routes, Azure Bastion, and Private DNS, these controls establish a layered network architecture designed around centralized security, workload isolation, and future hybrid connectivity.