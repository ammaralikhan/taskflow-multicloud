**TaskFlow: Zero-Cost Multicloud DevOps Pipeline**

A secure, containerized Node.js API deployed across **Azure** and **GCP** using **CI/CD**, **infrastructure-as-code**, and **security scanning** — all within **free-tier limits**.

> **Live GCP Endpoint (Free)**:  
> [https://taskflow-gcp-466496905373.us-central1.run.app](https://taskflow-gcp-466496905373.us-central1.run.app)

> Azure App Service was validated and then **deleted** to maintain **$0 operational cost**.

---

Goal

Demonstrate **true multicloud parity** by deploying the **same Docker image** to:
- Azure App Service (Linux Container, West Europe)
- GCP Cloud Run (Serverless, us-central1)

All while enforcing:
- **Security scanning** (Trivy + `npm audit`)
- **Immutable infrastructure** (same image, same tag)
- **Zero long-term cost** (free tiers only)

---

**Architecture Overview**

```plaintext
[GitHub Repository]
        ↓
[Azure Pipelines] → [Docker Hub] → [Azure App Service] (validated, then deleted)
                          ↓
                  [GCP Cloud Run] ← (live, $0)
                          ↓
             [Terraform IaC (Azure + GCP)]
