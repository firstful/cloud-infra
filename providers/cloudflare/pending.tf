# Deliberately NOT declared yet — see docs/CLOUDFLARE-INVENTORY.md.
#
# Zone settings, zone/account rulesets (WAF, rate limits), Workers Routes and
# KV namespaces could not be read with any available token. They must be
# enumerated with the Read scopes in TOKEN.md before resources are added here.
# Do not assume "none in use" until those GETs succeed.
#
# R2 object-lifecycle rules are clickops-only: cloudflare/cloudflare v4 has no
# lifecycle resource. The live rule expire-email-raw-after-14d (maxAge 1209600)
# is documented, not managed.
