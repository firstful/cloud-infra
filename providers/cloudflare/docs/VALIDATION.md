# Validation log — 2026-11-23

Run on `sutliffserver` with OpenTofu (provider `cloudflare/cloudflare` 4.52.10,
locked in `.terraform.lock.hcl`), against the pushed branch `cf-full-iac`
(PR #5). No Cloudflare write calls were made.

```
$ cd providers/cloudflare
$ tofu init -backend=false -input=false -no-color
Successfully configured the backend "s3"! OpenTofu will automatically use this backend unless the backend configuration changes.
OpenTofu has been successfully initialized!

$ tofu fmt -check -recursive
# no output (exit 0)

$ tofu validate -no-color
Success! The configuration is valid.
```

Earlier iterations caught and fixed three issues; the final run is clean:
- `data.cloudflare_tunnel.id` is not configurable → switched to
  `cloudflare_zero_trust_tunnel_cloudflared` lookup by name.
- `cloudflare_worker_script` is deprecated → switched to
  `cloudflare_workers_script`.
- `cloudflare_tunnel_config` is deprecated → switched to
  `cloudflare_zero_trust_tunnel_cloudflared_config`.

## Not run

`tofu plan` is intentionally not run: the current tokens cannot read zone
settings, rulesets, Workers Routes or KV, and no dedicated IaC token has been
minted yet. `TOKEN.md` lists the exact scopes and read-only verification
commands. The adoption gate is a clean plan after that token is installed.

CI status on PR #5 at the time of writing: `tofu / check` in progress; merge to
`main` blocked pending required approvals.
