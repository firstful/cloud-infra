# Access applications — adopted from Cloudflare 2026-11-19.

resource "cloudflare_zero_trust_access_application" "obsidian_ffilt_us" {
  account_id                 = var.account_id
  name                       = "obsidian"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = false
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "email_ffilt_us_ingest" {
  account_id                 = var.account_id
  name                       = "email-ingest (worker path)"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "proto_ffilt_us" {
  account_id                 = var.account_id
  name                       = "proto.ffilt.us"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = false
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "home_ffilt_us" {
  account_id                 = var.account_id
  name                       = "CI home.ffilt.us"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "gitea_ffilt_us" {
  account_id                 = var.account_id
  name                       = "gitea.ffilt.us"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = false
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "identity_ffilt_us" {
  account_id                 = var.account_id
  name                       = "CI identity.ffilt.us"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "jellyfin_ffilt_us" {
  account_id                 = var.account_id
  name                       = "CI jellyfin.ffilt.us"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "jelly_ffilt_us" {
  account_id                 = var.account_id
  name                       = "CI jelly.ffilt.us"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "telemetry_ffilt_us" {
  account_id                 = var.account_id
  name                       = "telemetry.ffilt.us"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "apps_ffilt_us" {
  account_id                 = var.account_id
  name                       = "CI apps.ffilt.us"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "talaria_ffilt_us" {
  account_id                 = var.account_id
  name                       = "CI talaria.ffilt.us"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = true
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "life_ws" {
  account_id                 = var.account_id
  name                       = "life-websocket-bypass"
  type                       = "self_hosted"
  session_duration           = "24h"
  auto_redirect_to_identity  = false
  allowed_idps               = []
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = false
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "wildcard_ffilt_us" {
  account_id                = var.account_id
  name                      = "*"
  type                      = "self_hosted"
  session_duration          = "24h"
  auto_redirect_to_identity = true
  allowed_idps = [
    "2b8ef251-dc93-4da2-bf45-f5b8c203a15e",
  ]
  app_launcher_visible       = true
  enable_binding_cookie      = false
  http_only_cookie_attribute = false
  options_preflight_bypass   = false
  tags                       = []

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}

resource "cloudflare_zero_trust_access_application" "warp_login" {
  account_id                = var.account_id
  name                      = "Warp Login App"
  type                      = "warp"
  session_duration          = "24h"
  auto_redirect_to_identity = false
  allowed_idps              = []
  tags                      = []
  app_launcher_visible      = false # provider defaults true; CF has false

  # CF does not return domain/destinations on read; attachment is left to Access.
  lifecycle {
    ignore_changes = [domain, destinations, policies]
  }
}
