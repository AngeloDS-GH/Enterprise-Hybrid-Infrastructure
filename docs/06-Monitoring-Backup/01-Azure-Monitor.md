# Azure Monitor

## Overview

Azure Monitor was implemented as the centralized monitoring platform for the DmonTech Azure environment.

The solution provides operational visibility by collecting platform logs, monitoring Azure resources, generating alerts for administrative activities, and centralizing telemetry within a Log Analytics Workspace.

Microsoft Sentinel was integrated with Azure Monitor to establish the foundation for future security monitoring and incident investigation.

---

# Business Requirements

The organization required:

- Centralize Azure monitoring.
- Collect Azure platform logs.
- Detect important administrative operations.
- Prepare the environment for security monitoring.
- Support future troubleshooting and operational reporting.

---

# Solution Overview

The monitoring solution consists of the following Azure services:

- Azure Monitor
- Log Analytics Workspace
- Activity Log Diagnostic Settings
- Alert Rules
- Azure Workbooks

These services work together to collect, store, visualize, and analyze monitoring data across the Azure subscription.

---

# Log Analytics Workspace

A Log Analytics Workspace was deployed as the central repository for monitoring and security logs.

Workspace

```
law-dmontech-prod-01
```

Region

```
East US 2
```

The workspace stores Azure Activity Logs and serves as the data source for Microsoft Sentinel and Azure Monitor.

---

# Azure Monitor Alert Rules

An Azure Monitor Alert Rule was created to monitor administrative operations performed within the Azure subscription.

Alert Rule

```
alert-admin-operations-01
```

Scope

```
Azure Subscription
```

Signal

```
All Administrative Operations
```

The alert provides visibility into management activities and can be extended in the future by integrating Action Groups for email notifications, automation, or incident response.

---

# Diagnostic Settings

Azure Activity Logs were configured to be exported to the Log Analytics Workspace.

Diagnostic Setting

```
diag-subscription-law
```

Destination

```
law-dmontech-prod-01
```

The following Activity Log categories were enabled:

- Administrative
- Security
- Service Health
- Alert
- Recommendation
- Policy
- Autoscale
- Resource Health

This configuration centralizes subscription-level logs for monitoring, reporting, and future security analysis.

---

# Azure Workbook

An Azure Workbook was created to provide a centralized monitoring dashboard.

Workbook

```
wb-dmontech-monitoring-01
```

The workbook serves as the foundation for future monitoring dashboards by consolidating Azure Monitor, Log Analytics, and Microsoft Sentinel information into a single view.

---

# Architecture

```
Azure Resources
        │
        ▼
Activity Logs
        │
        ▼
Diagnostic Settings
        │
        ▼
Log Analytics Workspace
        │
        ├────────► Azure Monitor
        │
        └────────► Microsoft Sentinel
                        │
                        ▼
                Workbooks & Alert Rules
```

---

# Validation

The following validations were completed:

- Azure Monitor configured.
- Log Analytics Workspace deployed.
- Diagnostic Settings configured successfully.
- Azure Activity Logs exported successfully.
- Alert Rule created.
- Workbook created and saved.
- Microsoft Sentinel successfully integrated with the workspace.

---

# Operational Benefits

Azure Monitor provides several operational advantages:

- Centralized monitoring.
- Historical log collection.
- Operational visibility.
- Administrative activity tracking.
- Improved troubleshooting.
- Integration with Microsoft Sentinel.
- Foundation for future automation and reporting.

---

# Lessons Learned

Azure Monitor is significantly more powerful when combined with Log Analytics and Microsoft Sentinel.

Rather than monitoring resources individually, centralizing telemetry simplifies troubleshooting, improves operational awareness, and creates a scalable monitoring platform that can grow alongside the Azure environment.

This implementation establishes the monitoring foundation required for enterprise-scale Azure environments.

---

# Screenshots

-Alert Rule
![Alert Rule](../../images/Alert-rule.png)
-Diagnostic Settings
![Diagnostic Settings](../../images/Diagnostic-settings.png)
-Azure Workbook
![Azure Workbook](../../images/Monitor-workbook.png)