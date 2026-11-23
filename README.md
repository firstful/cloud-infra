# cloud-infra

IaC for Reed's cloud provider accounts. **OpenTofu only** (declarative, no
clickops). Targets:

- **OCI** (us-chicago-1, free-tier-only) in `providers/oci/`
- **Cloudflare** (all Sutliff edge config) in `providers/cloudflare/`

## Layout

- `providers/oci/` — the OCI tenancy root module (VCN, subnet, instance, etc.)
- `providers/cloudflare/` — Cloudflare zone/DNS, Access, tunnel ingress,
  Worker/R2/Queue/Email Routing, and pending zone settings/rulesets. See its
  README and `TOKEN.md`.
- `.gitea/workflows/tofu.yml` — CI: fmt + validate + plan on PR, gated apply
  on manual dispatch; apply is never automatic.
- `.gitea/workflows/drift.yml` — scheduled drift plan (detailed exit code).

## Rules

1. **Zero spend** (see cloud profile SOUL.md): every resource must be
   Always-Free-eligible. `plan` must show no cost-incurring changes.
2. State is remote in the OCI free-tier Object Storage bucket, keyed per
   provider. Never commit `*.tfstate*`, `.terraform/`, or secrets.
3. Cloudflare credentials: Gitea Actions secret `CLOUDFLARE_API_TOKEN`.
   Exact required scopes are documented in `providers/cloudflare/TOKEN.md`.
   Do not reuse an in-use operational token; do not print or commit values.
4. Adoption gate: import existing resources by ID and reach a clean `tofu
   plan` before applying anything. Unreadable surfaces stay documented in
   `providers/cloudflare/docs/CLOUDFLARE-INVENTORY.md`, not guessed at.
