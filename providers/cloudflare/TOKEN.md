# Cloudflare API token requirements

One purpose-built token is required. Do **not** re-scope an in-use token
(`cf-mint-ci`, `cf-email-ops`, DNS/tunnel tokens, `rook-access-policy-updater`):
they are consumed by running services and have no clean rollback. Mint a new
`cloud-infra IaC` token via the `cf-mint-token` profile and store its value as
the Gitea repository secret `CLOUDFLARE_API_TOKEN`.

Account: `224469ecf8e8a619106fe8ffa19c7a43`
Zones: `ffilt.us` (`b36262ee7b94037531e8f833a408a7df`),
`arewefucked.xyz` (`2d40df21712448ee9a3e82c4e5d1943c`)

## Exact permissions

Zone resources — scope to both zones above:

| Permission | Why |
|---|---|
| `Zone Read` | enumerate zones |
| `DNS Read` + `DNS Write` | `cloudflare_record` (23 records) |
| `Zone Settings Read` + `Zone Settings Write` | verify and manage non-default SSL/cache settings |
| `Workers Routes Read` + `Workers Routes Write` | explicit worker routes |

Rulesets have **no zone-level permission group** in the token UI. Use the
account-scoped `Account Rulesets Read` + `Account Rulesets Write` (accepts
both `/accounts/{id}/rulesets` and `/zones/{id}/rulesets`). Product-specific
equivalents such as `Zone WAF Read/Write`, `Zone Transform Rules Read/Write`
(UI: **Transform Rules** under Zone permissions; account-scoped
`Transform Rules` is a separate group), `Dynamic URL Redirects Read/Write`
and `Mass URL Redirects Read/Write` also work for their own rulesets, but
`Account Rulesets` is the single broad one.

Account resources — scope to the account above:

| Permission | Why |
|---|---|
| `Cloudflare Tunnel Read` + `Write` | tunnel + ingress config |
| `Access: Apps and Policies Read` + `Write` | 13 apps / ~25 policies |
| `Workers Scripts Read` + `Write` | `email-ingest` worker |
| `Workers KV Storage Read` + `Write` | verify/manage KV namespaces |
| `Workers R2 Storage Read` + `Write` | `ffilt-us-email-raw` bucket |
| `Queues Read` + `Write` | `email-ingest-queue` + consumer |
| `Email Routing Rules Read` + `Write` | catch-all rule |

A single token with all of the above is broader than any current token. If
least privilege is preferred, split into two CI secrets (zone/DNS/settings vs
account edge/email) and add two provider aliases, but that adds state and
workflow complexity; the single token is the recommended starting point.

## What is missing today

Live probes on 2026-11-23 showed all available tokens failing with CF errors
`9109`/`10000` on: `/zones/{z}/settings`, zone rulesets, account rulesets,
Workers Routes, and Workers KV Storage. The readable token set is fragmented:

- `Cloudflare API Token (ffilt.us)` — zones read, DNS write, tunnels only
- `cf-mint-ci` / `rook-access-policy-updater` — Access apps, tunnels, worker list
- `cf-email-ops` — R2, Queue, Email Routing, one Worker, page-rules read
- `cf-drainer` — R2 + Queue
- `Cloudflare Master Token (API Tokens Write)` — only `/user/tokens`, and its
  dashboard WAN-IP filter goes stale on ISP rotation (error 9109), which also
  breaks `cf-mint-token` until Reed updates it

## Verification

```bash
# token validity (no secrets in logs)
curl -s -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
  https://api.cloudflare.com/client/v4/user/tokens/verify

# read-only probes that currently fail and must succeed with the new token
for z in b36262ee7b94037531e8f833a408a7df 2d40df21712448ee9a3e82c4e5d1943c; do
  curl -sf -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    "https://api.cloudflare.com/client/v4/zones/$z/settings" >/dev/null || echo "settings FAIL $z"
  curl -sf -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    "https://api.cloudflare.com/client/v4/zones/$z/rulesets" >/dev/null || echo "rulesets FAIL $z"
done
```

Then run `tofu plan` against this repo with the new token. The acceptance gate
for full adoption is a clean plan (no creates/deletes) with import blocks in
place. Never print or commit the token; CI reads it from `CLOUDFLARE_API_TOKEN`.
