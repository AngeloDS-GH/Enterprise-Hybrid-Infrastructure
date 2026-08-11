# DmonTech Azure Infrastructure — Terraform

## Overview

This directory contains the Infrastructure as Code (IaC) implementation of the DmonTech Enterprise Hybrid Infrastructure project.

The Terraform configuration reproduces the core Azure infrastructure architecture implemented manually during the project, including Hub-Spoke networking, centralized security, routing, private connectivity, and secure Azure Storage.

The objective is to demonstrate the ability to design, document, and automate enterprise Azure infrastructure using reusable and maintainable Infrastructure as Code practices.

---

## Architecture

The Terraform deployment implements the following logical architecture:

```text
Azure Subscription
│
├── Hub Resource Group
│   │
│   └── Hub Virtual Network
│       │
│       ├── GatewaySubnet
│       ├── AzureFirewallSubnet
│       ├── AzureFirewallManagementSubnet
│       │
│       └── Azure Firewall
│           └── Firewall Policy
│
│              VNet Peering
│                   │
│                   ▼
│
└── Spoke Resource Group
    │
    └── Spoke Virtual Network
        │
        ├── Workload Subnet
        │   ├── Network Security Group
        │   ├── Route Table
        │   └── Storage Private Endpoint
        │
        └── Application Gateway Subnet

Secure Storage
│
├── Azure Storage Account
├── Azure Files
├── Blob Containers
├── Lifecycle Management
├── Private Endpoint
└── Private DNS Zone
```

---

## Infrastructure Components

### Resource Organization

The deployment separates infrastructure into dedicated Resource Groups for:

- Hub networking and centralized security
- Spoke application workloads

Common tags are applied to resources to provide consistent identification and management.

### Hub-Spoke Networking

The network architecture includes:

- Hub Virtual Network
- Spoke Virtual Network
- Bidirectional VNet Peering
- Dedicated workload subnet
- Dedicated Application Gateway subnet
- Gateway subnet
- Azure Firewall subnets
- User-Defined Routing (UDR)

The Spoke workload subnet uses a default route (`0.0.0.0/0`) with Azure Firewall configured as the virtual appliance next hop.

### Network Security

Network security controls include:

- Azure Firewall Standard
- Azure Firewall Policy
- Network Security Group (NSG)
- HTTP and HTTPS workload rules
- NSG-to-subnet association
- Centralized traffic routing through the Hub

The Azure Firewall private IP is referenced dynamically by the Spoke route configuration rather than being statically hardcoded.

### Secure Storage

The storage architecture includes:

- Standard LRS Storage Account
- Public network access disabled
- Minimum TLS 1.2
- Private Blob containers
- Azure Files share
- Storage lifecycle management
- Blob Private Endpoint
- Azure Private DNS integration

Private connectivity ensures that Blob Storage can be accessed through the Spoke network without exposing the storage data plane directly to the public internet.

### Storage Lifecycle Management

The archival container uses lifecycle policies to automatically manage data:

- Move blobs to Cool tier after 30 days
- Move blobs to Archive tier after 90 days
- Delete blobs after 365 days

This demonstrates automated storage cost optimization.

---

## Terraform File Structure

```text
terraform/
├── providers.tf
├── variables.tf
├── main.tf
├── networking.tf
├── security.tf
├── storage.tf
├── outputs.tf
├── terraform.tfvars.example
└── README.md
```

### `providers.tf`

Defines:

- Terraform version requirements
- AzureRM provider
- Azure subscription configuration

### `variables.tf`

Contains reusable variables for:

- Subscription
- Azure region
- Resource Groups
- VNets
- Subnets
- Security resources
- Storage resources
- Common tags

### `main.tf`

Defines the core Resource Groups used by the architecture.

### `networking.tf`

Defines:

- Hub VNet
- Spoke VNet
- Subnets
- VNet Peering
- Route Table
- User-Defined Route
- Route Table association

### `security.tf`

Defines:

- Network Security Group
- NSG rules
- Azure Firewall Policy
- Azure Firewall
- Firewall Public IP resources
- NSG subnet association

### `storage.tf`

Defines:

- Azure Storage Account
- Azure Files share
- Blob containers
- Lifecycle Management Policy
- Private Endpoint
- Private DNS Zone
- Private DNS VNet Link

### `outputs.tf`

Returns useful deployment information including:

- Resource Group names
- VNet names and IDs
- Subnet IDs
- NSG information
- Azure Firewall addresses
- Storage resources
- Private Endpoint information

### `terraform.tfvars.example`

Provides an example variable configuration without exposing real subscription information or sensitive values.

---

## Prerequisites

The following tools are required:

- Terraform
- Azure CLI
- Azure subscription
- Permissions to create Azure resources

Authentication can be performed using Azure CLI:

```powershell
az login
```

Verify the active Azure subscription:

```powershell
az account show
```

If multiple subscriptions are available, select the appropriate subscription before using Terraform.

---

## Configuration

Create a local `terraform.tfvars` file based on:

```text
terraform.tfvars.example
```

Example:

```hcl
subscription_id = "YOUR-AZURE-SUBSCRIPTION-ID"
```

The real `terraform.tfvars` file should not be committed when it contains environment-specific or sensitive values.

---

## Terraform Initialization

Initialize the working directory:

```powershell
terraform init
```

This downloads the required AzureRM provider and initializes Terraform.

---

## Format Validation

Format all Terraform configuration files:

```powershell
terraform fmt
```

---

## Configuration Validation

Validate the Terraform configuration:

```powershell
terraform validate
```

A successful validation should return:

```text
Success! The configuration is valid.
```

---

## Deployment Preview

Generate an execution plan before deploying infrastructure:

```powershell
terraform plan
```

Review the plan carefully before making changes to an Azure environment.

---

## Deployment

To deploy the infrastructure:

```powershell
terraform apply
```

Terraform will display the proposed changes and request confirmation before creating the resources.

> **Note:** Azure Firewall and other enterprise Azure services can generate significant costs. Review the Terraform execution plan and Azure pricing before deploying the complete lab environment.

---

## Destroying Lab Resources

When the lab environment is no longer required:

```powershell
terraform destroy
```

Always review the destroy plan before confirming resource deletion.

---

## Security Considerations

This repository does not intentionally store:

- Azure credentials
- Client secrets
- Storage Account keys
- Access tokens
- Private keys

Sensitive or environment-specific values should be supplied locally or through a secure CI/CD secret-management mechanism.

---

## Infrastructure as Code Objectives

This Terraform implementation demonstrates:

- Infrastructure as Code
- Azure resource dependency management
- Reusable configuration through variables
- Hub-Spoke network automation
- Centralized network security
- Private Azure service connectivity
- Secure Storage deployment
- Automated lifecycle management
- Consistent resource tagging
- Repeatable Azure infrastructure deployment

---

## Project Context

This Terraform implementation is part of the **Enterprise Hybrid Infrastructure** portfolio project.

The broader project includes hands-on implementations of:

- Azure Hub-Spoke networking
- Azure Firewall
- VPN connectivity
- Network Security Groups
- Azure Virtual Machines
- Azure Storage
- Private Endpoints
- Private DNS
- Load balancing
- Application delivery
- Azure Policy
- Key Vault
- Microsoft Defender for Cloud
- Azure Monitor
- Azure Backup and Recovery
- Cost Management
- Hybrid infrastructure architecture

Terraform is used to demonstrate how the core infrastructure can transition from manual deployment to a repeatable Infrastructure as Code model.

---

## Author

**Angelo Solano**

Microsoft Certified: Azure Administrator Associate (AZ-104)

Enterprise Hybrid Infrastructure & Cloud Engineering Portfolio