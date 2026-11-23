# Cloudflare Declarative-Configuration Audit

Author: Rook · Date: 2026-11-23 · READ-ONLY audit (GET-only CF API calls; no live config changed, no git repos modified)

## 1. Method & evidence

- Live Cloudflare API v4 GETs using **vaulted** tokens from `/home/eizooz/homelab-creds.kdbx` (pykeepass via the Hermes venv). No secret values appear in this report. Full JSON responses cached under `/tmp/cf-audit-cache{,2,3}/` (mode 0700).
- Cross-checked against `reeds/homelab-docs` (docs MCP), `reeds/cloud-infra`, `reeds/cf-manager`, `reeds/sutliff-cluster` (Gitea MCP), and the in-progress `/tmp/sutliff-dns` scaffold (read only; that repo is being built by another task — untouched).
- CF account `224469ec…a43`, USER `51cb1eae…3af`.

### Bottom line

**Almost none of the Cloudflare configuration is declarative today.** Estimated ~10–15% declarative: DNS is *being* declared (in-progress octoDNS scaffold), k8s-side routing/tunnel Secret is in Flux git-ops, and a partial OpenTofu Access-app scaffold exists — but Access apps/policies, tunnel ingress, R2/Queue/Worker/Email-Routing, and all zone settings are **live-clicked or API-mutated with no repo as source of truth**. There is no single repo that owns Cloudflare.

## 2. Zone inventory (live API — authoritative)

Exactly **two zones** on the account (confirmed via `/zones` with three independent tokens):

| Zone | Zone ID | Status | Role |
|---|---|---|---|
| `ffilt.us` | `b36262ee7b94037531e8f833a408a7df` | active | primary homelab zone: tunnel CNAME, Access, mail, public sites |
| `arewefucked.xyz` | `2d40df21712448ee9a3e82c4e5d1943c` | **pending** | DNS + orange-cloud proxy only; site is an Azure SWA, not tunneled |

No other zones exist. `*.ffilt.us` split-DNS bypass lives in OPNsense Unbound, not Cloudflare.

### DNS records (live snapshots)

`ffilt.us` — 16 records:

| Type | Name | Content | Proxied | Note |
|---|---|---|---|---|
| CNAME | `ffilt.us` | `orange-glacier-0be44f40f.2.azurestaticapps.net` | yes | **apex CNAME = CF flattening** → Azure SWA blog |
| CNAME | `blog.ffilt.us` | same Azure SWA | yes | CNAME |
| CNAME | `*.ffilt.us` | `8f3e5dfe-…-5876b.cfargotunnel.com` | yes | **wildcard → tunnel** (all single-label hosts) |
| CNAME | `autoconfig.ffilt.us`, `autodiscover.ffilt.us`, `mail.ffilt.us` | `privateemail.com` | yes | Namecheap mail |
| MX | `ffilt.us` | `mx1.privateemail.com`, `mx2.privateemail.com` (10/20) | no | mailbox |
| MX | `ffilt.us` | `route1.mx.cloudflare.net` (1) | no | CF Email Routing catch-all |
| SRV | `_autodiscover._tcp.ffilt.us` | `0 443 privateemail.com` | no | mail autodiscover |
| TXT | `ffilt.us` | SPF `include:spf.privateemail.com ~all` | no | |
| TXT | `ffilt.us` | `_rmj8m20m4jiov7890uzrfkbija86158` (SWA verify) + `j0rhybb5…` (CF verify) | no | two co-existing TXTs at apex |
| TXT | `_dmarc.ffilt.us` | `v=DMARC1; p=none; rua=mailto:a1ff64a6…` | no | |
| TXT | `default._domainkey.ffilt.us` | DKIM (Namecheap) | no | |
| TXT | `blog.ffilt.us` | `_floqpemdjg6dbwu4gtkuckhbyzsg7fk` (Azure asuid) | no | |

`arewefucked.xyz` — 7 records: apex CNAME → `white-cliff-09a42e610.3.azurestaticapps.net` (proxied, flattened), 5 Namecheap MX (`eforward1-5.registrar-servers.com`), 1 SPF TXT.

Caveat: another background task is adding a TXT record right now; re-run the export before any import so it isn't lost.

## 3. Item-by-item inventory

Legend — Source of truth: **UI/API-clicked** (no repo), **Partial** (some declarative fragment exists), **Declarative** (in git). Pain: Low / Med / High.

| # | Item | Live state (verified) | Source of truth today | Where it lives | Pain to bring under mgmt |
|---|---|---|---|---|---|
| 1 | DNS zones + records | 23 records across 2 zones; apex + wildcard CNAMEs (flattening) | **Partial** — octoDNS scaffold being built, not applied | `reeds/sutliff-dns` (empty on Gitea); working copy `/tmp/sutliff-dns/{octodns.yaml,zones/*.yaml}`; token via `${CLOUDFLARE_TOKEN}` | **Low** — records already enumerated; preserve `proxied` flag + apex CNAME semantics |
| 2 | Cloudflare Tunnel (connector) | 1 tunnel `Ffiltus` `8f3e5dfe…`, **healthy**, 2 live connections | **Partial** — connector Deployment is Flux git-ops; token is an imperative k8s Secret | `reeds/sutliff-cluster` `infra/cloudflared/`; Secret `cloudflared-token` (created by hand, from file) | **Med** — TF can declare the tunnel + token resource; connector run-token still has to be seeded as a k8s Secret (or fetched from API at deploy time) |
| 3 | Tunnel ingress config | 3 rules: `smoke.ffilt.us` → traefik, `*.ffilt.us` → traefik, catch-all `http_status:404` (last, required); warp-routing off | **UI/API-clicked** — was PUT via API after a `config: null` crash-loop incident; not in any repo that I can confirm | live tunnel configuration endpoint only | **Med** — declare via `cloudflare_tunnel_config` or a `cloudflared` config file in git; do not lose the catch-all 404 |
| 4 | Access applications | **13 apps** (12 `self_hosted` + 1 WARP login) | **Hybrid/imperative** — created by `cf-manager POST /access/apps` / one-off curl; some app IDs hardcoded in cf-manager env | cf-manager SQLite (`/data/cf-manager.db`) + `HOME_IP_APPS` env (jelly `b533e3a8`, wildcard `2cccdc35`, gitea `9469779d`) + runbooks | **Med** — 13 apps / ~25 policies; straightforward to declare, but must coordinate with cf-manager so it doesn't re-create/drift them |
| 5 | Access policies | ~25 policies: `allow_me` (email), service-token `non_identity`, `bypass` (telemetry, everyone), `Home WAN IP bypass` (ip) | **UI/API-clicked + dynamic** — home-IP bypass mutated every 15 min by cf-manager/cron | cf-manager + `cf-home-ip-sync.py` cron | **Med-High** — dynamic IP bypass conflicts with TF ownership; use `lifecycle.ignore_changes` on the bypass policy, or have cf-manager update a TF-owned IP *list* instead |
| 6 | Page rules | **0** (verified via the one token with Page Rules read) | n/a — none in use | — | Low (nothing to migrate) |
| 7 | Redirect rules / Transform rules | No evidence of CF-side redirect rules. Apex `ffilt.us` redirect is implemented **in-cluster** (Traefik `ffilt-redirect` IngressRoute, `HostRegexp ^ffilt\.us$`) | **Declarative** (in-cluster) | `reeds/sutliff-cluster` `kube-system/ffilt-redirect` | Low — stays in k8s; a historical `ffilt-redirect-creator` token exists (unused now) |
| 8 | WAF / Rate limiting / Firewall rules | No CF-managed WAF or rate-limit rules found on any readable endpoint. Per-IP rate limiting for telemetry is **app-side** (Go, keyed on `Cf-Connecting-Ip`). Zone rulesets endpoint is unreadable by on-box tokens → cannot 100% exclude hidden rulesets | n/a / **unknown** | — | **Med (verification)** — mint a `Zone Rulesets Read` token and confirm empty before declaring "none" |
| 9 | Workers | **1** script: `email-ingest` (modified 2026-10-21), catch-all Email Routing target, `workers_dev=false` | **Partial** — deployed via `wrangler`/API from the mail pipeline work; source likely under `reeds/email-sync` or a worker dir (confirm) | `reeds/email-sync` (source), live script via CF API | **Med** — source exists in git; add a `cloudflare_worker_script` + bindings to IaC or keep wrangler deploy in CI with the script tracked |
| 10 | Workers Routes | Not readable with available token scope; no evidence of explicit routes (Email Routing worker uses routing-rule target, not a Workers Route) | unknown | — | Low — enumerate with a Workers Read token during migration |
| 11 | KV namespaces | **0 readable** (all tokens 10000). Docs mention legacy `email-drainer (kv+queue)` tokens and `email-kvtest` — likely abandoned in favor of R2. Confirm none live | **UI/API-clicked (legacy)** | — | Low-Med — verify empty; if any exist, declare with `cloudflare_kv_namespace` |
| 12 | R2 buckets | `ffilt-us-email-raw` (created 2026-10-21) + lifecycle rule `expire-email-raw-after-14d` (`deleteObjectsTransition`, maxAge 1209600 s) + default multipart abort. Also a transient scratch bucket `rook-lcsweep-*` from the lifecycle watcher cron — **ignore/exclude** | **UI/API-clicked** — lifecycle set via `PUT /accounts/…/r2/buckets/…/lifecycle`; not in git | live CF API only | **Med** — declare bucket + lifecycle in TF; exclude watcher scratch bucket |
| 13 | Queues | `email-ingest-queue` id `c2435a66416048258d583d59879389fe`, retention 86400 s, `http_pull` consumer (batch 10, 3 retries, 30 s visibility) | **UI/API-clicked** | live CF API only | **Med** — `cloudflare_queue` exists in the TF provider; consumer secret handling needed |
| 14 | Email Routing | Catch-all rule `catch-all -> ingest worker (store all, no forward)` → `email-ingest` worker; MX `route1.mx.cloudflare.net` at DNS | **UI/API-clicked** | live CF API only | **Med** — TF provider has `cloudflare_email_routing_*` resources; keep destination addresses out of git if personal |
| 15 | SSL/TLS, cache, zone settings, Spectrum, Images | Unreadable with on-box tokens (9109/10000). Known only: proxied CNAMEs, CF-edge TLS + Access; no evidence of Spectrum or Images use | **UI/API-clicked (assumed)** | CF dashboard | **Med (verification)** — a Zone Read token can enumerate `/zones/{z}/settings`; declare the non-default ones |
| 16 | API tokens (17 live) | Master `Create Additional Tokens` (WAN-IP-bound, stales on ISP change), `cf-mint-ci`, `Ffiltus`, `Ffiltus DNS+SSL`, `rook-access-policy-updater`, several duplicate/stale email tokens (`email-drainer` ×2, `email-worker-deploy` ×2, dashboard token-creators) | **Vault + imperative** | KeePass `/home/eizooz/homelab-creds.kdbx` + root-only files `/root/.cf-*-token` + k8s Secrets | **Med** — document + prune; tokens themselves should NOT be TF-managed (bootstrap credentials), but their *scopes* should be reviewed |
| 17 | Cloudflare Access service tokens (per-device) | Minted dynamically by cf-manager `/mint` for APKs/apps; stored in cf-manager SQLite | **Dynamic (correctly so)** | cf-manager PVC | **Low — leave dynamic.** This is runtime data, never a git resource |

## 4. Credential / secret situation

- **No single token can read/write everything.** Capability matrix (live-verified):
  - `Cloudflare API Token (ffilt.us)` (vault, zone `b36262ee…`) — zones read, DNS write; sees 2 zones + tunnel; **cannot** read Access apps, R2, Queue, rulesets, zone settings.
  - `cf-mint-ci` / `rook-access-policy-updater` — Access apps (13), tunnels, workers list.
  - `cf-email-ops` — R2 buckets, Queue, email routing rules, 1 Worker; page rules read (0).
  - `cf-drainer` — R2 + Queue (consumer).
  - `Cloudflare Master Token (API Tokens Write)` — only `/user/tokens` (all 17) + permission groups; **WAN-IP-bound** and goes stale on ISP rotation (9109), which also breaks `cf-mint-token` minting until Reed refreshes the dashboard IP filter.
  - `.hermes/.env` `CF_API_TOKEN` is a stub per standing ops note — **verify any token with `/user/tokens/verify` before relying on it**. (This audit used vault tokens only.)
- **Secrets source of truth:** KeePass `/home/eizooz/homelab-creds.kdbx` (master at `/home/eizooz/.kdbx-master.txt`), plus root-only token files and k8s Secrets (`cloudflared-token`, `cf-manager-token`, `cf-manager-tunnel-token`, `email-cf-drainer`). Never commit values; reference via env/secret store.
- **For a declarative repo** the practical model is: mint one purpose-built CI token per area (or a single broad "infra-as-code" token) via `cf-mint-token` profiles, store the value as a Gitea Actions repo secret / k8s Secret, and keep the master in the vault only for rotation. Note the master's WAN-IP filter must be current before any minting.
- **`cloud-infra` state caveat:** its README currently says state stays on the runner volume (encrypted at rest), with remote state deferred. For a repo that owns *all* Cloudflare (incl. Access), that is fragile — recommend an R2-backed OpenTofu state (free tier, no new spend) with versioning.

## 5. Recommendation — one repo, one tool

### Tool choice: Terraform/OpenTofu Cloudflare provider, not octoDNS

- **octoDNS only owns DNS.** It cannot express Access apps/policies, tunnel + ingress, WAF/rulesets, Workers, R2, Queue, Email Routing, or zone settings. Using it as the primary tool would leave ~80% of the surface click-ops.
- **The Cloudflare provider covers everything actually in use** (DNS records incl. proxied CNAMEs, `cloudflare_tunnel`/`cloudflare_tunnel_config`, `cloudflare_access_application`/`…_policy`, `cloudflare_worker_script`, `cloudflare_r2_bucket`, `cloudflare_queue`, `cloudflare_email_routing_rule`, `cloudflare_zone_settings_override`, rulesets) in one state file with plan/drift detection.
- **Precedent already exists:** `reeds/cloud-infra` is OpenTofu-only with `providers/cloudflare/` (Access apps/policies scaffold) and `.gitea/workflows/tofu.yml` (fmt/validate/plan on PR, gated apply on main). That is the natural single home.
- Recommendation: **make `reeds/cloud-infra` the single Cloudflare repo** (rather than creating yet another). If Reed prefers a clean repo name, fork it to `reeds/cloudflare-control` — but do not keep `sutliff-dns` as a second DNS owner.

### Proposed single-repo structure (`reeds/cloud-infra`)

```
reeds/cloud-infra/
├─ providers/
│  ├─ cloudflare/                 # all CF edge config, one OpenTofu root module
│  │  ├─ main.tf                  # provider + locals (account/zone ids)
│  │  ├─ variables.tf             # secrets via TF_VAR_* / env, never checked in
│  │  ├─ dns.tf                   # cloudflare_record for both zones (ported from octoDNS YAML)
│  │  ├─ access.tf                # 13 apps + ~25 policies (import by id)
│  │  ├─ tunnel.tf                # Ffiltus tunnel + ingress config (smoke, *.ffilt.us, 404 catch-all)
│  │  ├─ workers.tf               # email-ingest worker + bindings/routes
│  │  ├─ r2-queue.tf              # ffilt-us-email-raw + lifecycle, email-ingest-queue + consumer
│  │  ├─ email-routing.tf         # catch-all → email-ingest
│  │  ├─ zone-settings.tf         # only non-default SSL/cache/zone settings
│  │  ├─ imports.tf               # terraform import blocks for existing resources
│  │  └─ README.md
│  └─ oci/                        # existing OCI free-tier module (unchanged)
├─ dns-export/                    # generated CF DNS export / octoDNS-compatible YAML, reference only
├─ .gitea/workflows/tofu.yml      # CI: fmt+validate+plan on PR; gated apply on main
└─ .gitea/workflows/drift.yml     # scheduled tofu plan -detailed-exitcode → alert if drift
```

### Coexistence / merge with `sutliff-dns`

- `sutliff-dns` was created 2026-11-23 and is **still empty on Gitea**; the working scaffold is `/tmp/sutliff-dns/{octodns.yaml,zones/ffilt.us.yaml,zones/arewefucked.xyz.yaml,scripts/import_cf_export.py}` (octoDNS + `octodns_cloudflare`, token via `CLOUDFLARE_TOKEN`, no live apply without manual dispatch). Another task is building it — do not disturb that work mid-flight.
- Merge path once that task finishes:
  1. Treat its `zones/*.yaml` as the **import inventory** (all 23 records, with `proxied` flags and apex CNAMEs). They already encode the flattening behavior.
  2. Translate each into `cloudflare_record` in `dns.tf` (a small generator script is fine; keep the generated file reviewed).
  3. **Stop at one writer.** Do not run `octodns-sync` and `tofu apply` against the same records — that creates permanent drift. Archive `sutliff-dns` as read-only history (or delete it after the import is verified). If Reed insists on keeping octoDNS as the DNS front-end, use the octoDNS **YamlProvider as source + a Terraform data source reading those YAMLs** — but that is two tools for one surface and is not recommended.
  4. Keep the octoDNS-derived `dns-export/` YAML in the repo as a human-readable inventory/diff artifact, generated from `tofu show` or the CF API, not as a second source of truth.

### cf-manager's role after migration (do not delete it)

cf-manager does genuinely dynamic runtime work that IaC cannot replace: per-device Access service-token minting (`/mint`), short-lived API tokens (`/tokens/mint`), tunnel health, and the 15-minute Home-WAN-IP bypass sync. Keep it, but:
- The **static** Access apps/policies it currently creates should be declared in `access.tf` and imported by ID.
- The **dynamic** "Home WAN IP bypass" policies must be excluded from TF ownership (`lifecycle { ignore_changes = [...] }`) or refactored so cf-manager updates a TF-owned IP list rather than the policy objects directly. Otherwise the two writers fight every 15 minutes.
- Secrets (`cf-manager-key`, `cf-manager-token`, `cf-manager-tunnel-token`) stay out of git.

## 6. Suggested migration sequence (low-risk)

1. **Verify unknowns first** (read-only): mint `zone-read` + `rulesets-read` + `workers-routes-read` tokens; dump `/zones/{z}/settings`, zone + account rulesets, workers routes, KV. Confirm "none in use" before declaring it.
2. Re-export DNS (the concurrent TXT addition may have landed) into `dns-export/`.
3. Stand up `providers/cloudflare/` in `cloud-infra` with **import blocks only** — no changes — and run `tofu plan` until it reports zero diffs against live state. This is the acceptance gate for "fully declared".
4. Declare tunnel ingress, Access (minus dynamic bypass), Worker, R2 lifecycle, Queue, Email Routing. Plan until clean.
5. Add the scheduled drift check + PR gating; flip `sutliff-dns` to archive.
6. **Never** apply against the `arewefucked.xyz` zone until its `status=pending` is understood (delegation may not be fully active); its records are simple enough to import last.

## 7. Open items needing Reed

- Confirm the `email-ingest` Worker source location so it can be tracked in-repo.
- Confirm whether any CF WAF/rate-limit/zone settings exist that available tokens cannot read (or approve minting a read token).
- Decide repo name (`cloud-infra` consolidation vs new `cloudflare-control`) and R2-backed remote state for OpenTofu.
- Decide the fate of `sutliff-dns` once the current scaffolding task completes (archive vs delete).
