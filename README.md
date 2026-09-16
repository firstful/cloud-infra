# cloud-infra

IaC for Reed's cloud provider accounts. **OpenTofu only** (declarative, no
clickops). Currently targets: **OCI** (us-chicago-1, free-tier-only).

## Layout

- `providers/oci/` — the OCI tenancy root module (VCN, subnet, instance, etc.)
- `.gitea/workflows/tofu.yml` — CI: fmt + validate + plan on PR, apply on main (manual gate)

## Rules

1. **Zero spend** (see cloud profile SOUL.md): every resource must be
   Always-Free-eligible. `plan` must show no cost-incurring changes.
2. State is remote (Gitea backend, `reeds/cloud-infra-state` repo, OCI-compatible
   backend via local minio NOT needed — using Gitea's generic backend is not
   supported; we use the **local backend on the runner with state in the repo is
   FORBIDDEN** (secrets). Instead: OCI Object Storage backend (free 20GB tier)
   once the tenancy is wired; until then state stays on the runner volume,
   encrypted at rest by the runner disk.
3. Never commit `*.tfstate*`, `.terraform/`, or any OCID-bearing secrets.
   OCI API key lives outside the repo (runner env / /home/cloud/.oci).
