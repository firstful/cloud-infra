# Cloudflare Tunnel: the connector object carries a write-only secret, so it is
# treated as bootstrap state and read by name. Its ingress configuration is
# fully owned here. Do not delete the catch-all 404 rule.

data "cloudflare_zero_trust_tunnel_cloudflared" "ffiltus" {
  account_id = var.account_id
  name       = "Ffiltus"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "ffiltus" {
  account_id = var.account_id
  tunnel_id  = data.cloudflare_zero_trust_tunnel_cloudflared.ffiltus.id

  config {
    ingress_rule {
      hostname = "smoke.ffilt.us"
      service  = "http://traefik.kube-system.svc.cluster.local:80"
    }
    ingress_rule {
      hostname = "*.ffilt.us"
      service  = "http://traefik.kube-system.svc.cluster.local:80"
    }
    ingress_rule {
      service = "http_status:404"
    }
    warp_routing {
      enabled = false
    }
  }
}
