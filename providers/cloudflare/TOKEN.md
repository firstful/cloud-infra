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
| `Zone:Zones Read` | enumerate zones |
| `Zone:DNS Read` + `Zone:DNS Edit` | `cloudflare_record` (23 records) |
| `Zone:Zone Settings Read` + `Zone:Zone Settings Edit` | verify and manage non-default SSL/cache settings |
| `Zone:Rulesets Read` + `Zone:Rulesets Edit` | WAF / rate-limit / redirect rulesets |
| `Zone:Workers Routes Read` + `Zone:Workers Routes Edit` | explicit worker routes |

Account resources — scope to the account above:

| Permission | Why |
|---|---|
| `Account:Cloudflare Tunnel Read` + `Edit` | tunnel + ingress config |
| `Account:Cloudflare Access Read` + `Edit` (Apps and Policies) | 13 apps / ~25 policies |
| `Account:Workers Scripts Read` + `Edit` | `email-ingest` worker |
| `Account:Workers KV Storage Read` + `Edit` | verify/manage KV namespaces |
| `Account:R2 Read` + `Edit` | `ffilt-us-email-raw` bucket |
| `Account:Queues Read` + `Edit` | `email-ingest-queue` + consumer |
| `Account:Email Routing Read` + `Edit` | catch-all rule |

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
