# 🔐 Secure Azure Storage Architecture

## 📌 Business Requirement

DmonTech requires a secure and scalable storage platform capable of supporting application data, archival data, and shared file workloads while minimizing public exposure.

The storage architecture must:

- Restrict storage exposure from the public Internet.
- Provide private connectivity from Azure workloads.
- Support object and file-based storage.
- Separate operational data from archival data.
- Automate long-term data lifecycle management.
- Optimize storage consumption and long-term costs.
- Integrate with the existing Hub-Spoke network architecture.

---

## 🎯 Objective

The objective of this implementation is to deploy a secure Azure Storage architecture using:

- Azure Storage Account.
- Azure Blob Storage.
- Azure Files.
- Azure Private Endpoint.
- Azure Private DNS.
- Private Blob containers.
- Lifecycle Management.

The resulting architecture provides private data-plane connectivity while supporting different workload and retention requirements.

---

## 🏗️ Architecture

The primary storage resource deployed for the DmonTech environment is:

| Setting | Value |
|---|---|
| Storage Account | `stspokeprod01` |
| Resource Group | `rg-spoke-prod-01` |
| Performance | Standard |
| Redundancy | LRS |
| Public Network Access | Disabled |

The Storage Account acts as the centralized storage platform for Blob and Azure Files workloads.

Public network access was disabled as part of the security design, preventing direct data-plane connectivity from the public Internet.

### Private Endpoint

A Private Endpoint was deployed to provide private connectivity to the Blob service.

| Setting | Value |
|---|---|
| Private Endpoint | `pe-stspokeprod01-blob` |
| Target Resource | `stspokeprod01` |
| Target Sub-resource | Blob |
| Connectivity | Private Link |
| Public Access | Disabled |

Private Endpoint connectivity allows workloads inside the Azure network to reach the Storage Account through a private IP address rather than through its public endpoint.

This supports the broader Zero Trust architecture by reducing unnecessary public exposure of storage resources.

### Private DNS Integration

Private DNS was integrated with the Storage Account Private Endpoint using:

```text
privatelink.blob.core.windows.net
```

The Private Endpoint integration creates the required private DNS resolution path so that requests for the Storage Account Blob endpoint resolve to its internal Private Endpoint address.

```text
Azure Workload
      |
      v
  Spoke VNet
      |
      v
 Private DNS
      |
      v
Private Endpoint
      |
      v
 Azure Storage
```

This keeps storage traffic within the Azure private networking architecture.

---

## 📂 Storage Services

### Azure Files

Azure Files was implemented to demonstrate managed SMB file storage within the DmonTech environment.

| Setting | Value |
|---|---|
| File Share | `dmontech-files` |
| Storage Account | `stspokeprod01` |
| Access Tier | Transaction optimized |
| Quota | 100 TiB |
| Soft Delete | 14 days |

Azure Files provides managed file shares without requiring the organization to deploy and maintain a traditional Windows file server.

The service can support workloads requiring shared file access while benefiting from Azure Storage availability and management capabilities.

### Blob Storage

Blob Storage was configured to provide object storage for application and archival data.

| Container | Purpose | Public Access |
|---|---|---|
| `app-data` | Application and operational data | Private |
| `archive` | Long-term archival data | Private |

Anonymous access was disabled for both containers.

Separating active application data from archival data allows different lifecycle and retention strategies to be applied according to the purpose of the stored information.

---

## ♻️ Lifecycle Management

Azure Storage Lifecycle Management was implemented to automatically transition archival data between storage tiers as it ages.

The policy created for the project is:

```text
lifecycle-archive-data
```

The policy applies specifically to Block Blobs using the prefix:

```text
archive/
```

This prevents the lifecycle policy from affecting application data stored outside the archival container.

The following lifecycle strategy was implemented:

| Data Age | Action |
|---|---|
| More than 30 days | Move to Cool tier |
| More than 90 days | Move to Archive tier |
| More than 365 days | Delete blob |

The lifecycle progression follows:

```text
Archive Container
       |
       v
      Hot
       |
    30 Days
       |
       v
      Cool
       |
    90 Days
       |
       v
    Archive
       |
   365 Days
       |
       v
     Delete
```

This provides automated cost optimization without requiring administrators to manually move old data between storage tiers.

The rule was intentionally scoped to:

```text
archive/
```

This ensures that archival data follows the lifecycle policy while operational data remains unaffected.

```text
stspokeprod01
│
├── app-data
│   └── Operational application data
│
└── archive
    │
    ├── 0-30 days
    │      Hot
    │
    ├── 30-90 days
    │      Cool
    │
    ├── 90-365 days
    │      Archive
    │
    └── >365 days
           Delete
```

---

## 🔐 Security

The Storage Account was designed around restricted access and workload isolation.

Key security controls include:

- Public network access disabled.
- Private Endpoint connectivity.
- Private DNS integration.
- Private Blob containers.
- Anonymous Blob access disabled.
- Azure RBAC for authorization.
- Network-level isolation through the Spoke architecture.

The resulting security model is:

```text
               Internet
                  X
                  |
            Azure Workload
                  |
                  v
              Spoke VNet
                  |
                  v
          Private Endpoint
                  |
                  v
           stspokeprod01
                  |
          +-------+-------+
          |               |
          v               v
     Azure Files      Blob Storage
                          |
                    +-----+-----+
                    |           |
                    v           v
                app-data     archive
                                |
                                v
                         Lifecycle Policy
```

This architecture reduces direct exposure of the storage layer while providing different storage services according to workload requirements.

---

## 📸 Evidence

### Azure Files

![Azure Files Share](../../images/azure-files.png)

*Azure Files share `dmontech-files` configured within the DmonTech Storage Account.*

### Blob Storage

![Azure Blob Containers](../../images/containers.png)

*Private Blob containers `app-data` and `archive` configured within `stspokeprod01`.*

### Lifecycle Management

![Azure Storage Lifecycle Policy](../../images/lifecycle-management-rule.png)

*Lifecycle policy `lifecycle-archive-data` automatically transitioning archival blobs through Cool and Archive tiers before deletion.*

---

## 🧠 Architectural Decisions

### Private Connectivity

Public network access was disabled and Private Link was selected as the primary data-plane connectivity model.

This reduces the attack surface of the Storage Account and prevents workloads from depending on Internet-accessible storage endpoints.

### Operational and Archival Data Separation

`app-data` and `archive` were separated into different Blob containers.

This provides logical workload separation and allows lifecycle policies to target archival information without affecting active application data.

### Private Containers by Default

Anonymous Blob access was not enabled.

Storage objects therefore require authenticated and authorized access rather than being publicly retrievable.

### Automated Lifecycle Management

Lifecycle Management was selected instead of manually moving aging data between storage tiers.

This provides a repeatable and automated retention strategy while reducing administrative overhead.

### LRS for the Lab Environment

Locally Redundant Storage was selected for the project environment to demonstrate the architecture while maintaining reasonable lab costs.

Higher redundancy options could be selected in a production environment according to business continuity and disaster recovery requirements.

---

## 💰 Cost Management

Storage cost optimization was incorporated directly into the architecture.

The Lifecycle Management policy automatically moves aging archival data toward lower-cost storage tiers:

```text
Frequently Accessed
        |
        v
       Hot
        |
        v
       Cool
        |
        v
     Archive
        |
        v
      Delete
```

The implemented strategy:

- Keeps recently created archival data in the Hot tier.
- Transitions data older than 30 days to Cool.
- Transitions data older than 90 days to Archive.
- Automatically deletes archival data older than 365 days.

This approach avoids storing all data indefinitely in frequently accessed storage tiers.

Standard LRS was also selected to provide an appropriate cost profile for the lab environment.

---

## ⚙️ Operational Considerations

The storage implementation demonstrates several operational principles:

- Different storage services should be selected according to workload requirements.
- Storage should not be publicly accessible unless there is a specific business requirement.
- Private Link provides private data-plane connectivity to Azure PaaS services.
- Private DNS provides transparent name resolution for Private Endpoint resources.
- Blob containers should remain private by default.
- Lifecycle policies can automate storage cost optimization.
- Archival and operational data should be logically separated when they require different retention strategies.

---

## ✅ Validation

| Capability | Status |
|---|---|
| Azure Storage Account | ✅ Completed |
| Standard LRS Storage | ✅ Completed |
| Public Network Access Disabled | ✅ Completed |
| Private Endpoint | ✅ Completed |
| Private DNS Integration | ✅ Completed |
| Azure Files | ✅ Completed |
| Blob Storage | ✅ Completed |
| Private Blob Containers | ✅ Completed |
| Lifecycle Management | ✅ Completed |
| Cool Tier Transition | ✅ Configured |
| Archive Tier Transition | ✅ Configured |
| Automatic Deletion | ✅ Configured |

The implementation demonstrates that DmonTech workloads can use multiple Azure Storage services while maintaining a private connectivity model and automated data lifecycle strategy.

---

## 📚 Lessons Learned

Azure Storage provides multiple services within a common storage platform, but each service addresses different workload requirements.

Azure Files provides managed shared file storage, while Blob Storage provides scalable object storage suitable for application data, logs, backups, and archival information.

Private Endpoint integration significantly changes the security model by allowing Azure Storage to operate without relying on public network connectivity.

Lifecycle Management also demonstrates that cloud architecture is not only about deploying infrastructure. Data placement and retention decisions directly affect long-term operational costs.

Combining private connectivity, logical data separation, and automated lifecycle management creates a storage architecture that addresses security, operations, and cost simultaneously.

---

## 🏁 Result

The DmonTech Azure environment successfully implemented a secure and cost-aware storage architecture.

The final solution includes:

- Standard LRS Azure Storage.
- Private Endpoint connectivity.
- Private DNS integration.
- Azure Files.
- Private Blob containers.
- Separation between operational and archival data.
- Automated Lifecycle Management.
- Cool and Archive tier transitions.
- Automatic deletion of aged archival data.

Together, these components provide a storage platform designed around **private connectivity, workload flexibility, security, and long-term cost optimization**.