# Azure VNet with Terraform/OpenTofu – Training Examples

This directory contains all progressive examples used with the **terraform-az-fk-vnet** module.
The examples are designed as **incremental building blocks**, starting from a minimal Azure Virtual Network
and gradually preparing it for real-world workloads such as **AKS** and **Private Endpoints**.

These examples are part of the **FoggyKitchen.com** training ecosystem and are used across Azure
and multicloud courses (AKS, networking, Private Endpoints, and beyond).

---

## 🧭 Example Overview

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Basic VNet** | Minimal VNet with a single subnet (hello world) |
| 02 | **VNet with Multiple Subnets** | Multiple subnets and Service Endpoints |
| 03 | **AKS Minimal Network** | Minimal AKS-ready subnet design (no placeholders) |
| 04 | **Private Endpoints Ready** | Dedicated subnet for Private Endpoints with real usage |

Each example builds on the **concepts** introduced in the previous one, but can be applied
independently for learning and experimentation.

---

## ⚙️ How to Use

Each example directory contains:
- Terraform/OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the goal of the example
- A minimal, runnable architecture (no dummy resources)

To run an example:

```bash
cd examples/03-aks-minimal
tofu init
tofu plan
tofu apply
```

You can apply examples independently, but the **recommended approach is sequential**:
01 → 02 → 03 → 04

This mirrors real-world network design, where complexity is added only when required.

---

## 🧩 Design Principles

- One example = one architectural goal
- No unused or placeholder subnets
- Clear separation of concerns
- Networking designed to be consumed by other modules (AKS, Private Endpoints, etc.)

These examples intentionally avoid:
- Full landing zones
- Opinionated enterprise frameworks
- Hidden dependencies between examples

---

## 🧩 Related Resources

- [FoggyKitchen Azure VNet Module (terraform-az-fk-vnet)](../)
- [FoggyKitchen AKS Module (terraform-az-fk-aks)](https://github.com/mlinxfeld/terraform-az-fk-aks)
- [OCI OKE Module (terraform-oci-fk-oke)](https://github.com/mlinxfeld/terraform-oci-fk-oke)

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](../LICENSE) for details.

---

© 2025 [FoggyKitchen.com](https://foggykitchen.com) — *Cloud. Code. Clarity.*

