# terraform-az-fk-vnet

This repository contains a reusable **Terraform/OpenTofu module** and progressive examples for deploying an **Azure Virtual Network (VNet)** with **subnets**, designed for real-world cloud architectures and hands-on learning.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses/azure-fundamentals-terraform-course/)** and serves as a foundational building block for Azure and multicloud courses, including AKS, Private Endpoints, and advanced networking scenarios.

This module is also part of the **[Azure Fundamentals with Terraform/OpenTofu — Build Real-World Azure Architectures with Reusable Modules (2026 Edition)](https://foggykitchen.com/courses/azure-fundamentals-terraform-course/)** course. In the training, it is used as the base networking layer for workloads, private connectivity, and secure access patterns built throughout the labs.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Used By

This module is used as a building block by the higher-level [FoggyKitchen Landing Zone Orchestrator](https://github.com/foggykitchen/foggykitchen-landing-zone-orchestrator), where it is composed into Azure, OCI, and multicloud landing zone patterns.

## 🎯 Purpose

The goal of this module is to provide a **clean, composable, and educational reference implementation** for Azure networking:

- Focused only on **VNet + Subnets**
- No hidden magic or implicit resources
- Designed to be consumed by other modules (AKS, Private Endpoints, Bastion, etc.)

This is **not** a full Landing Zone or CAF replacement — it is a **learning-first, architecture-aware module**.

---

## ✨ What the module does

The module creates:

- Azure Virtual Network (VNet)
- One or more Subnets (map-based)
- Optional:
  - Service Endpoints
  - Subnet delegations
  - Private Endpoint–ready subnets

The module intentionally does **not** create:
- NSGs
- Route Tables
- NAT Gateway
- Bastion
- Firewall
- VNet Peering

Each of those concerns belongs in its own dedicated module.

---

## 📂 Repository Structure

```bash
terraform-az-fk-vnet/
├── examples/
│   ├── 01-basic-vnet/
│   ├── 02-vnet-with-subnets/
│   ├── 03-aks-minimal/
│   ├── 04-private-endpoints/
│   └── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

All examples are runnable and demonstrate **incremental network design**, from the simplest VNet to AKS-ready and Private Endpoint–ready layouts.

---

## 🚀 Example Usage

```hcl
module "vnet" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-vnet.git?ref=v0.1.1"

  name                = "fk-vnet-demo"
  location            = "westeurope"
  resource_group_name = "rg-fk-demo"

  address_space = ["10.10.0.0/16"]

  subnets = {
    aks = {
      address_prefixes = ["10.10.10.0/22"]
    }
  }

  tags = {
    project = "foggykitchen"
    env     = "dev"
  }
}
```

---

## ⚙️ Module Inputs

### Core inputs

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `name` | `string` | ✅ | VNet name |
| `location` | `string` | ✅ | Azure region |
| `resource_group_name` | `string` | ✅ | Resource Group name |
| `address_space` | `list(string)` | ✅ | VNet CIDR blocks |
| `subnets` | `map(object)` | ✅ | Subnet definitions |
| `tags` | `map(string)` | ❌ | Resource tags |

### Subnet object schema

```hcl
subnets = map(object({
  address_prefixes  = list(string)
  service_endpoints = optional(list(string), [])

  delegations = optional(list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  })), [])

  private_endpoint_network_policies = optional(string, "Enabled")
  private_link_service_network_policies_enabled = optional(bool, true)
}))
```

---

## 📤 Outputs

| Output | Description |
|------|-------------|
| `vnet_id` | VNet resource ID |
| `vnet_name` | VNet name |
| `subnet_ids` | Map of subnet name → subnet ID |
| `subnet_address_prefixes` | Map of subnet name → list of CIDR prefixes |
| `subnets` | Map of subnet name → subnet attributes (id, name, address_prefixes) |

---

## 🧩 Examples Overview

| Example | Description |
|-------|-------------|
| `01-basic-vnet` | Minimal VNet + single subnet |
| `02-vnet-with-subnets` | Multiple subnets and service endpoints |
| `03-aks-minimal` | Minimal AKS-ready subnet design |
| `04-private-endpoints-ready` | Dedicated subnet for Private Endpoints with real usage |

See [`examples/`](examples) for details.

---

## 🧠 Design Philosophy

- Explicit over implicit
- Small modules over monoliths
- Each subnet exists **only when something uses it**
- Optimized for **learning, reuse, and composition**

This makes the module ideal for:
- Training material
- Architecture workshops
- Reference implementations
- Multicloud comparisons (Azure ↔ OCI)

---

## 🧩 Related Modules & Training

- [terraform-az-fk-nsg](https://github.com/foggykitchen/terraform-az-fk-nsg)
- [terraform-az-fk-loadbalancer](https://github.com/foggykitchen/terraform-az-fk-loadbalancer)
- [terraform-az-fk-compute](https://github.com/mlinxfeld/terraform-az-fk-compute)
- [terraform-az-fk-disk](https://github.com/foggykitchen/terraform-az-fk-disk)
- [terraform-az-fk-storage](https://github.com/foggykitchen/terraform-az-fk-storage)
- [terraform-az-fk-aks](https://github.com/mlinxfeld/terraform-az-fk-aks)

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
