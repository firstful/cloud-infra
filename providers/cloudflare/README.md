# Cloudflare Access — OpenTofu

Declarative source of truth for `*.ffilt.us` Access **applications** and
**policies**. Adopted 2026-11-19 after the `obsidian.ffilt.us` clickops bypass
incident.

## State and credentials

- State: same OCI Object Storage bucket as `providers/oci`, key
  `cloudflare/terraform.tfstate`. S3 creds come from
  `OCI_TFSTATE_S3_ACCESS` / `OCI_TFSTATE_S3_SECRET` CI secrets.
- Cloudflare token: Gitea repo secret `CLOUDFLARE_API_TOKEN`, needs
  **Access: Apps and Policies Read + Write**. Do not reuse the cf-manager key.
- Apply is manual-only (`workflow_dispatch`) in `.gitea/workflows/tofu.yml`.
  PRs get fmt/validate/plan.

## Files

| File | Contents |
|---|---|
| `main.tf` | provider, backend |
| `apps.tf` | 14 Access applications |
| `policies.tf` | 26 unique policies (one shared by obsidian + wildcard) |
| `imports.tf` | one-time adoption IDs, safe to keep |
| `service-tokens.tf` | IDs of existing tokens referenced by policies (tokens remain cf-manager-owned) |

## Ownership boundary

- **IaC owns:** application settings and policy name/decision/precedence/rules.
- **cf-manager owns:** service token mint/rotate (`/mint`), token removal,
  `/home-ip/sync`, tunnel health, user token minting.
- **Not in state:** DNS records, tunnel ingress, WAF.

`Home WAN IP bypass` policies (proto, gitea, jelly, wildcard) are rewritten by
cf-manager every 15 min; those four resources ignore `include/exclude/require`
so plans stay clean. Proto's copy is not currently synced by cf-manager but is
treated the same way for consistency.

Applications ignore `domain`, `destinations` and `policies`: Cloudflare's read
API does not return those fields for self-hosted apps, and attachments are
managed by the policy resources' `application_id`. If you add a **new** app,
create it once with `domain` set in config (or via cf-manager
`POST /access/apps`), import it, then move `domain` into `ignore_changes`.

One reusable `allow_me` policy (`f7be1119…`) is attached to both
`obsidian.ffilt.us` and `*.ffilt.us`. The v4 provider models it as app-scoped,
so it is declared once under the obsidian app; the wildcard attachment remains
in Cloudflare but is not represented in state. Avoid changing that policy in
place — prefer two separate policies.

## Guardrail

Any `decision = "bypass"` policy with `include { everyone = true }` must have
an explicit allowlist entry in this README. Current public hosts:
`telemetry.ffilt.us` (`public-bypass`) and `life.ffilt.us/ws/*` (`bypass`).

`blog.ffilt.us` had a bypass app deleted during cleanup; verify before adding.

## Verify after CI apply

```bash
curl -sI --resolve obsidian.ffilt.us:443:<edge-ip> https://obsidian.ffilt.us/
# expected: 302 -> sutliff.cloudflareaccess.com
```

Pin a real edge IP with DoH (`accept: application/dns-json`); LAN split DNS
hits Traefik directly and never exercises Access.
