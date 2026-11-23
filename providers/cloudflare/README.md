# Cloudflare — OpenTofu

Single declarative source of truth for the Sutliff Cloudflare footprint:
Access apps/policies, DNS for both zones, tunnel ingress, the email stack
(Worker + R2 + Queue + Email Routing), and — once readable — zone settings and
rulesets. Access was adopted 2026-11-19 after the `obsidian.ffilt.us` clickops
bypass incident; the rest was added 2026-11-23 from the read-only audit in
`docs/CLOUDFLARE-INVENTORY.md`.

## State and credentials

- State: same OCI Object Storage bucket as `providers/oci`, key
  `cloudflare/terraform.tfstate`. S3 creds come from
  `OCI_TFSTATE_S3_ACCESS` / `OCI_TFSTATE_S3_SECRET` CI secrets.
- Cloudflare token: Gitea repo secret `CLOUDFLARE_API_TOKEN`. The exact
  permissions for full management and verification are in `TOKEN.md`; the
  current fragmented tokens are **not** sufficient. Do not reuse the
  cf-manager key.
- Apply is manual-only (`workflow_dispatch`) in `.gitea/workflows/tofu.yml`.
  PRs get fmt/validate/plan.

## Files

| File | Contents |
|---|---|
| `main.tf` | provider, backend |
| `locals.tf` | zone IDs |
| `apps.tf` | Access applications |
| `policies.tf` | Access policies |
| `imports.tf` | Access adoption IDs, safe to keep |
| `service-tokens.tf` | IDs of existing tokens referenced by policies (tokens remain cf-manager-owned) |
| `dns.tf` / `imports_dns.tf` | 23 DNS records across both zones, with import IDs |
| `tunnel.tf` / `imports_extra.tf` | `Ffiltus` tunnel data source + ingress config |
| `email.tf` | R2 bucket, Queue, Worker (source in `files/email-ingest/`), Email Routing rule |
| `pending.tf` | Explicitly unmanaged items and why |
| `TOKEN.md` | Exact token scopes needed |
| `docs/CLOUDFLARE-INVENTORY.md` | Read-only audit behind this configuration |

## Adoption gate

With the new token in place, run `tofu plan` and confirm **zero** creates or
deletes before applying. TXT values mirror the API's quoted representation;
if the provider reports a text diff, reconcile it in config rather than
applying a change. Never apply to `arewefucked.xyz` until its `status=pending`
is understood.

## Ownership boundary

- **IaC owns:** application settings and policy name/decision/precedence/rules,
  DNS records, tunnel ingress, the email stack, and (once verified) zone
  settings and rulesets.
- **cf-manager owns:** service token mint/rotate (`/mint`), token removal,
  `/home-ip/sync`, tunnel health, user token minting, and R2 lifecycle rules
  (no provider resource exists for those).
- **Not in state:** the tunnel connector secret (write-only bootstrap), API
  tokens, and dynamic per-device Access service tokens.

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
