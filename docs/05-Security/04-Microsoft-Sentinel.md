# Microsoft Sentinel

## Overview

Microsoft Sentinel was deployed as the Security Information and Event Management (SIEM) solution for the DmonTech Azure environment.

The objective was to centralize security monitoring, collect telemetry from Azure resources, and provide a scalable platform for future threat detection, investigation, and incident response.

Microsoft Sentinel was connected to a Log Analytics Workspace, allowing Azure Activity Logs and future security data sources to be collected and analyzed from a single location.

---

# Business Requirements

The organization required:

- Centralize security monitoring.
- Prepare the environment for threat detection.
- Collect Azure Activity Logs.
- Support future security investigations.
- Integrate with Microsoft Defender for Cloud.

---

# Solution Overview

Microsoft Sentinel was enabled using an existing Log Analytics Workspace.

Workspace

```
law-dmontech-prod-01
```

Deployment Model

```
Workspace-based
```

Primary Data Source

```
Azure Activity Logs
```

This deployment establishes the foundation for centralized security monitoring across the Azure environment.

---

# Architecture

Microsoft Sentinel was configured using the following architecture:

```
Azure Resources
        │
        ▼
Azure Activity Logs
        │
        ▼
Log Analytics Workspace
        │
        ▼
Microsoft Sentinel
```

This architecture enables centralized log collection, analytics, incident investigation, and future automation.

---

# Monitoring Capabilities

Microsoft Sentinel provides:

- Centralized security monitoring.
- Log collection.
- Incident investigation.
- Security analytics.
- Threat hunting.
- Integration with Microsoft Defender for Cloud.
- Automation through Playbooks (future implementation).

Although advanced analytics rules and automation were not configured in this laboratory, the platform was fully prepared for future expansion.

---

# Validation

The following validations were completed:

- Log Analytics Workspace created.
- Microsoft Sentinel successfully enabled.
- Workspace connected successfully.
- Azure Activity Logs available for future ingestion.
- Sentinel deployment completed successfully.

---

# Security Benefits

Microsoft Sentinel improves security operations by providing:

- Centralized visibility.
- Cloud-native SIEM capabilities.
- Threat detection.
- Incident management.
- Integration with Azure security services.
- Scalable monitoring architecture.

---

# Lessons Learned

Microsoft Sentinel acts as the central security monitoring platform within Azure.

Deploying Sentinel early in a cloud environment allows organizations to build a scalable security operations capability as additional Azure services are deployed.

Using a shared Log Analytics Workspace simplifies data collection and reduces administrative complexity while preparing the environment for future security automation.

---

# Screenshots

-Microsoft Sentinel Overview
![Microsoft Sentinel Overview](../../images/Sentinel-overview.png)
