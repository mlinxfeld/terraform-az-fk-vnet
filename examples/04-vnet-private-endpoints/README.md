# Example 04: AKS + Azure Container Registry with Private Endpoint

In this example, we extend the previous AKS deployment by adding **Private Endpoint connectivity** to an **Azure Container Registry (ACR)**.

The goal is to demonstrate how **Azure Private Endpoints work in practice**, including:
- subnet separation,
- private DNS resolution,
- and secure, private access to a PaaS service from AKS.

This example intentionally focuses on **networking mechanics**, not application workloads.

---

## 🧭 Architecture Overview

<img src="04-vnet-private-endpoints.png" width="900"/>

This deployment creates:

- A dedicated **Virtual Network** (`fk-vnet-aks`)
- An **AKS subnet** used by the Kubernetes cluster  
- A **Private Endpoint subnet** dedicated to PaaS private endpoints
- An **Azure Container Registry** with:
  - public access disabled (or restricted)
  - **Private Endpoint enabled**
- A **Private DNS Zone** linked to the VNet

Traffic from AKS to ACR flows **entirely inside the virtual network**, without using public IPs.

---

## 🧱 Network Layout

- **VNet CIDR:** `10.10.0.0/16`
- **AKS subnet:** `10.10.8.0/22`
- **Private Endpoint subnet:** `10.10.20.0/24`

Each subnet has a clear, single responsibility:
- AKS nodes run only in the AKS subnet
- Private Endpoints live only in the Private Endpoint subnet

---

## 🚀 Deployment Steps

Initialize and apply the configuration:

```bash
tofu init
tofu plan
tofu apply
```

After the deployment completes, AKS and ACR are fully provisioned and connected through a Private Endpoint.

---

## 🖼️ Azure Portal View - ACR

### Azure Container Registry Private Access

After deployment, you should see the Azure Container Registry configured with **Private access**.

- A Private Endpoint connection is present
- The connection state is **Approved**
- The registry still uses the standard `*.azurecr.io` endpoint
- No public IP exposure is required

<img src="04-acr-private-endpoint-portal.png" width="900"/>

---

## 🖼️ Azure Portal View - Private Endpoint

The following screenshots confirm the final state of the deployment in the Azure Portal.
They demonstrate that AKS accesses Azure Container Registry entirely via a Private Endpoint,
with private DNS resolution and no public network exposure.

### Private DNS Zone

The Private DNS zone `privatelink.azurecr.io` is created and linked to the virtual network.
This zone is required for resolving the ACR private endpoint to a private IP address.

![Private DNS Zone - privatelink.azurecr.io](./04-acr-private-endpoint-dns-zone.png)

### Virtual Network Link

The Private DNS zone is explicitly linked to the AKS virtual network (`fk-vnet-aks`),
allowing workloads inside the VNet to resolve ACR private endpoints correctly.

![Private DNS Zone - Virtual Network Link](./04-acr-private-endpoint-dns-link.png)

### DNS Recordsets (Private Resolution)

Azure automatically creates A records inside the Private DNS zone for the ACR private endpoint.
These records map the registry hostname to private IP addresses from the
`fk-subnet-private-endpoints` subnet.

![Private DNS Zone - Recordsets](./04-acr-private-endpoint-recordsets.png)

---

## 🖼️ Azure Portal View - Private Endpoint's DNS Resolution

Private Endpoints do **not** introduce new service URLs.  
Instead, they work by **overriding DNS resolution** for existing service FQDNs.

The screenshot below shows the DNS configuration of the Private Endpoint:

- Standard ACR FQDNs are preserved:
  - `fkacrprivate.azurecr.io`
  - `fkacrprivate.westeurope.data.azurecr.io`
- DNS records resolve to **private IP addresses**
- The IPs belong to the **Private Endpoint subnet**
- No public IP addresses are used

This confirms that traffic to ACR is routed privately through the VNet.

<img src="04-acr-private-endpoint-dns.png" width="900"/>

---

## 🧠 Key Takeaways

This example demonstrates that:

- Private Endpoints secure access to Azure PaaS services **without changing service endpoints**
- DNS resolution is the key mechanism behind Private Endpoint connectivity
- Subnet separation is critical for clean and secure network design
- AKS can securely consume private PaaS services using standard Azure networking primitives

---

## 🧹 Cleanup

To remove all resources created by this example:

```bash
tofu destroy
```

---

## 🌐 Learn More

Visit [FoggyKitchen.com](https://foggykitchen.com/) for:
- Azure & OCI networking deep dives
- AKS and multicloud Terraform examples
- Hands-on Infrastructure as Code training

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](../../LICENSE) for details.

---

© 2025 [FoggyKitchen.com](https://foggykitchen.com) — *Cloud. Code. Clarity.*
