# Azure Load Balancing and Application Delivery

## Executive Summary

The DmonTech Azure networking architecture was extended with Azure Load Balancer and Azure Application Gateway to demonstrate Layer 4 and Layer 7 application delivery capabilities.

Azure Load Balancer was implemented to provide internal TCP traffic distribution to workloads inside the Spoke network.

Azure Application Gateway was then deployed to demonstrate HTTP-based Layer 7 application delivery using a dedicated Application Gateway subnet and a public frontend.

Together, these services demonstrate two different traffic distribution models available within Azure.

---

## 1. Architecture Overview

The implementation included:

| Component | Resource |
|---|---|
| Azure Load Balancer | `lb-app-prod-01` |
| Load Balancer SKU | Standard |
| Load Balancer Type | Internal |
| Backend Pool | `be-app-01` |
| Health Probe | `hp-http-01` |
| Load Balancing Rule | `rule-http-01` |
| Application Gateway | `agw-app-prod-01` |
| Application Gateway SKU | Standard_v2 |
| Application Gateway Subnet | `snet-appgw-01` |
| Application Gateway Public IP | `pip-agw-app-prod-01` |
| Backend Workload | `vm-spoke-app-02` |

The workload VM was located inside the Spoke workload network and was used as the backend target during the implementation.

---

# Azure Load Balancer

## 2. Internal Load Balancer

Azure Standard Load Balancer was deployed as an internal load-balancing service.

The resource was configured as:

```text
lb-app-prod-01
```

The Load Balancer used a private frontend address:

```text
10.1.1.6
```

Because the Load Balancer was internal, traffic distribution occurred through private networking rather than through a public Internet-facing frontend.

---

## 3. Backend Pool

A backend pool was created:

```text
be-app-01
```

The backend pool contained the application workload used during the project.

The purpose of the backend pool is to define the compute resources capable of receiving traffic from the Load Balancer.

Conceptually:

```text
Client
   |
   v
10.1.1.6
   |
   v
Azure Load Balancer
   |
   v
be-app-01
   |
   v
Application Workload
```

---

## 4. Health Probe

A TCP health probe was configured:

| Setting | Value |
|---|---|
| Probe | `hp-http-01` |
| Protocol | TCP |
| Port | 80 |

The health probe allows Azure Load Balancer to determine whether backend instances are available to receive traffic.

Unhealthy backend instances can therefore be excluded from traffic distribution.

---

## 5. Load Balancing Rule

The following rule was configured:

| Setting | Value |
|---|---|
| Rule | `rule-http-01` |
| Protocol | TCP |
| Frontend Port | 80 |
| Backend Port | 80 |
| Backend Pool | `be-app-01` |
| Health Probe | `hp-http-01` |

This configuration demonstrates Layer 4 traffic distribution based on TCP connections.

### Load Balancer Evidence

<!-- SCREENSHOT 1: lb-app-prod-01 Overview -->

![Azure Internal Load Balancer](../../images/lb-app-prod-01.png)

*Azure Standard Internal Load Balancer `lb-app-prod-01` configured with private frontend `10.1.1.6`, backend pool, TCP/80 health probe, and TCP/80 load-balancing rule.*

---

# Azure Application Gateway

## 6. Application Gateway Deployment

Azure Application Gateway was deployed to demonstrate Layer 7 application delivery.

The resource created was:

```text
agw-app-prod-01
```

Configuration:

| Setting | Value |
|---|---|
| Application Gateway | `agw-app-prod-01` |
| SKU | Standard_v2 |
| Region | East US 2 |
| Availability Zones | 1, 2, 3 |
| Virtual Network | `vnet-spk-workloads-01` |
| Dedicated Subnet | `snet-appgw-01` |
| Frontend Type | Public |
| Public IP | `pip-agw-app-prod-01` |
| Protocol | HTTP |
| Port | 80 |

The Standard_v2 deployment used a public frontend for the lab implementation.

---

## 7. Dedicated Application Gateway Subnet

Application Gateway requires dedicated subnet capacity.

A separate subnet was therefore created:

```text
snet-appgw-01
```

This keeps the Application Gateway infrastructure separated from the application workload subnet.

The network design follows:

```text
vnet-spk-workloads-01
│
├── snet-app-01
│      |
│      └── Application Workloads
│
└── snet-appgw-01
       |
       └── agw-app-prod-01
```

Separating application delivery infrastructure from workload compute provides a cleaner network architecture and supports independent service management.

---

## 8. Application Gateway Traffic Flow

Application Gateway operates at Layer 7 and can make routing decisions using HTTP/HTTPS information.

The lab traffic flow was designed as:

```text
Internet
   |
   v
pip-agw-app-prod-01
   |
   v
+----------------------+
| Application Gateway  |
| agw-app-prod-01      |
+----------------------+
   |
   | HTTP :80
   v
Backend Pool
   |
   v
vm-spoke-app-02
10.1.1.4
```

An HTTP listener received frontend traffic and forwarded requests toward the configured backend workload.

---

## 9. Backend Configuration

The application workload was configured as the backend target for Application Gateway.

```text
vm-spoke-app-02
```

Private address:

```text
10.1.1.4
```

The backend HTTP configuration used port:

```text
80
```

This demonstrated the relationship between:

```text
Frontend
   |
Listener
   |
Routing Rule
   |
Backend Pool
   |
Backend Setting
   |
Application Workload
```

---

## 10. Application Gateway Evidence

### Application Gateway Overview

<!-- SCREENSHOT 2: agw-app-prod-01 Overview -->

![Azure Application Gateway](../../images/agw-app-prod-01.png)

*Azure Application Gateway `agw-app-prod-01` deployed using Standard_v2 across Availability Zones 1, 2, and 3 with dedicated subnet `snet-appgw-01`.*

---

## 11. Load Balancer vs Application Gateway

The project demonstrates two different Azure traffic distribution technologies.

| Capability | Azure Load Balancer | Application Gateway |
|---|---|---|
| OSI Layer | Layer 4 | Layer 7 |
| Primary Protocols | TCP / UDP | HTTP / HTTPS |
| Routing Awareness | IP + Port | HTTP application traffic |
| Health Monitoring | Health Probes | Backend Health Probes |
| Internal Frontend | Supported | Supported depending on SKU/configuration |
| Public Frontend | Supported | Supported |
| HTTP-aware Routing | No | Yes |
| TLS Termination | No | Yes |
| Web Application Firewall | No | Available with WAF SKU |

Azure Load Balancer is appropriate when traffic needs to be distributed based primarily on transport-layer connectivity.

Application Gateway is designed specifically for web application delivery and provides HTTP-aware capabilities unavailable in a Layer 4 Load Balancer.

---

## 12. Combined Architecture

The two services demonstrate different positions in an enterprise application delivery architecture.

```text
                    Azure
                      |
        +-------------+-------------+
        |                           |
        v                           v
 Layer 4 Distribution        Layer 7 Distribution
        |                           |
        v                           v
 Azure Load Balancer       Application Gateway
 lb-app-prod-01            agw-app-prod-01
        |                           |
      TCP/80                      HTTP/80
        |                           |
        +-------------+-------------+
                      |
                      v
               Spoke Workloads
```

They were deployed independently during the lab to demonstrate their respective capabilities rather than being unnecessarily chained together.

---

## 13. Security Considerations

Several architectural decisions were incorporated into the implementation:

- The Azure Load Balancer used an internal private frontend.
- Backend workloads used private IP addressing.
- Application Gateway was isolated in a dedicated subnet.
- Workload traffic remained separated from Application Gateway infrastructure.
- Network Security Groups were implemented at the workload subnet.
- Public exposure was introduced only at the Application Gateway frontend required for the Standard_v2 lab deployment.
- Backend workloads themselves did not require direct public IP addresses.

This maintains separation between application delivery infrastructure and backend compute.

---

## 14. Cost Management

Both Azure Load Balancer and Application Gateway were deployed as temporary validation resources.

After configuration and evidence collection were completed, the resources were removed.

This was particularly important for Application Gateway because maintaining application delivery infrastructure without an active workload would create unnecessary Azure consumption.

The project therefore followed the resource lifecycle:

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

This allowed the architecture to be demonstrated while maintaining control over lab costs.

---

## 15. Validation Summary

The following capabilities were implemented:

| Capability | Status |
|---|---|
| Azure Standard Load Balancer | Completed |
| Internal Frontend | Completed |
| Private Frontend IP | Completed |
| Backend Pool | Completed |
| TCP Health Probe | Completed |
| TCP Load Balancing Rule | Completed |
| Azure Application Gateway | Completed |
| Standard_v2 SKU | Completed |
| Dedicated Application Gateway Subnet | Completed |
| Public Frontend | Completed |
| HTTP Listener | Completed |
| Backend Target | Completed |
| Layer 4 Traffic Distribution Design | Completed |
| Layer 7 Application Delivery Design | Completed |

---

## 16. Lessons Learned

Azure Load Balancer and Application Gateway solve different application delivery requirements and should not be treated as interchangeable services.

Azure Load Balancer provides high-performance Layer 4 traffic distribution without understanding the application protocol.

Application Gateway operates at Layer 7 and provides web-specific routing capabilities based on HTTP and HTTPS traffic.

The implementation also demonstrated the importance of subnet planning. Application Gateway requires dedicated subnet capacity, meaning application delivery requirements should be considered during the initial VNet address-space design.

Finally, application delivery services can represent significant ongoing cost in laboratory environments. Temporary deployment, validation, documentation, and cleanup provide a practical way to demonstrate these technologies while controlling cloud consumption.

---

## Result

The DmonTech Azure environment successfully demonstrated both Layer 4 and Layer 7 traffic distribution.

The implementation included:

- Azure Standard Internal Load Balancer.
- Private frontend addressing.
- Backend pools.
- TCP health monitoring.
- TCP load-balancing rules.
- Azure Application Gateway Standard_v2.
- Dedicated Application Gateway subnet.
- HTTP listener and backend routing.
- Availability Zone-aware Application Gateway deployment.
- Integration with private Spoke workloads.

Together, these services demonstrate how Azure can provide different application delivery mechanisms depending on workload and networking requirements.