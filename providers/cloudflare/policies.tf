# Access policies — adopted from Cloudflare 2026-11-19.

resource "cloudflare_zero_trust_access_policy" "obsidian_ffilt_us_allow_me_f7be1119" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.obsidian_ffilt_us.id
  name           = "allow_me"
  decision       = "allow"
  precedence     = 1
  include {
    email = ["reedsut@gmail.com"]
  }
}

resource "cloudflare_zero_trust_access_policy" "email_ffilt_us_ingest_worker_service_token_non_identity_44eeb352" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.email_ffilt_us_ingest.id
  name           = "worker service token (non_identity)"
  decision       = "non_identity"
  precedence     = 1
  include {
    service_token = [local.service_tokens.email_ingest_worker] # email-ingest-worker
  }
}

resource "cloudflare_zero_trust_access_policy" "proto_ffilt_us_allow_me_ec35b752" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.proto_ffilt_us.id
  name           = "allow_me"
  decision       = "allow"
  precedence     = 1
  include {
    email = ["reedsut@gmail.com"]
  }
}

resource "cloudflare_zero_trust_access_policy" "proto_ffilt_us_proto_android_token_b7e17701" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.proto_ffilt_us.id
  name           = "proto-android token"
  decision       = "non_identity"
  precedence     = 2
  include {
    service_token = [local.service_tokens.proto_android] # proto-android
  }
}

resource "cloudflare_zero_trust_access_policy" "proto_ffilt_us_home_wan_ip_bypass_38314239" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.proto_ffilt_us.id
  name           = "Home WAN IP bypass"
  decision       = "non_identity"
  precedence     = 3
  include {
    ip = ["76.73.229.106/32"]
  }

  # cf-manager rewrites this policy to the current WAN IP every 15m.
  lifecycle {
    ignore_changes = [include, exclude, require]
  }
}

resource "cloudflare_zero_trust_access_policy" "proto_ffilt_us_ci_proto_ffilt_us_service_token_69d2f9a0" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.proto_ffilt_us.id
  name           = "CI proto.ffilt.us service token"
  decision       = "non_identity"
  precedence     = 4
  include {
    service_token = [local.service_tokens.ci_proto_ffilt_us] # ci-proto.ffilt.us
  }
}

resource "cloudflare_zero_trust_access_policy" "home_ffilt_us_allow_me_ci_home_ffilt_us_2179cd5f" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.home_ffilt_us.id
  name           = "allow_me_CI home.ffilt.us"
  decision       = "allow"
  precedence     = 1
  include {
    email = ["reedsut@gmail.com"]
  }
}

resource "cloudflare_zero_trust_access_policy" "gitea_ffilt_us_gitea_mirror_gh_actions_service_token_6f7247b1" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.gitea_ffilt_us.id
  name           = "Gitea mirror (GH Actions) service token"
  decision       = "non_identity"
  precedence     = 1
  include {
    service_token = [local.service_tokens.gitea_github_mirror] # gitea-github-mirror
  }
}

resource "cloudflare_zero_trust_access_policy" "gitea_ffilt_us_allow_me_e0f922b1" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.gitea_ffilt_us.id
  name           = "allow_me"
  decision       = "allow"
  precedence     = 2
  include {
    email = ["reedsut@gmail.com"]
  }
}

resource "cloudflare_zero_trust_access_policy" "gitea_ffilt_us_home_wan_ip_bypass_6f9fc699" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.gitea_ffilt_us.id
  name           = "Home WAN IP bypass"
  decision       = "non_identity"
  precedence     = 3
  include {
    ip = ["76.73.229.106/32", "2603:6010:4d05:a100::/64"]
  }

  # cf-manager rewrites this policy to the current WAN IP every 15m.
  lifecycle {
    ignore_changes = [include, exclude, require]
  }
}

resource "cloudflare_zero_trust_access_policy" "gitea_ffilt_us_dashboard_proxy_swa_9cc23a26" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.gitea_ffilt_us.id
  name           = "Dashboard proxy (SWA)"
  decision       = "non_identity"
  precedence     = 4
  include {
    service_token = [local.service_tokens.dashboard_proxy_gitea] # dashboard-proxy-gitea
  }
}

resource "cloudflare_zero_trust_access_policy" "identity_ffilt_us_allow_me_4eedf0f4" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.identity_ffilt_us.id
  name           = "allow_me"
  decision       = "allow"
  precedence     = 1
  include {
    email = ["reedsut@gmail.com"]
  }
}

resource "cloudflare_zero_trust_access_policy" "jellyfin_ffilt_us_ci_jellyfin_service_token_15928447" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.jellyfin_ffilt_us.id
  name           = "CI jellyfin service token"
  decision       = "non_identity"
  precedence     = 1
  include {
    service_token = [local.service_tokens.dev_jellyfin] # dev-jellyfin
  }
}

resource "cloudflare_zero_trust_access_policy" "jelly_ffilt_us_allow_me_4a709c1b" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.jelly_ffilt_us.id
  name           = "allow_me"
  decision       = "allow"
  precedence     = 1
  include {
    email = ["reedsut@gmail.com"]
  }
}

resource "cloudflare_zero_trust_access_policy" "jelly_ffilt_us_ci_jelly_ffilt_us_service_token_300973b7" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.jelly_ffilt_us.id
  name           = "CI jelly.ffilt.us service token"
  decision       = "non_identity"
  precedence     = 2
  include {
    service_token = [local.service_tokens.ci_jelly_ffilt_us] # ci-jelly.ffilt.us
  }
}

resource "cloudflare_zero_trust_access_policy" "jelly_ffilt_us_home_wan_ip_bypass_bd86ee4b" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.jelly_ffilt_us.id
  name           = "Home WAN IP bypass"
  decision       = "non_identity"
  precedence     = 3
  include {
    ip = ["76.73.229.106/32"]
  }

  # cf-manager rewrites this policy to the current WAN IP every 15m.
  lifecycle {
    ignore_changes = [include, exclude, require]
  }
}

resource "cloudflare_zero_trust_access_policy" "telemetry_ffilt_us_public_bypass_4fd3dc60" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.telemetry_ffilt_us.id
  name           = "public-bypass"
  decision       = "bypass"
  precedence     = 1
  include {
    everyone = true
  }
}

resource "cloudflare_zero_trust_access_policy" "apps_ffilt_us_ci_apps_ffilt_us_service_token_0b7c35b0" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.apps_ffilt_us.id
  name           = "CI apps.ffilt.us service token"
  decision       = "non_identity"
  precedence     = 1
  include {
    service_token = [local.service_tokens.ci_apps_ffilt_us] # ci-apps.ffilt.us
  }
}

resource "cloudflare_zero_trust_access_policy" "apps_ffilt_us_allow_me_194025b4" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.apps_ffilt_us.id
  name           = "allow_me"
  decision       = "allow"
  precedence     = 2
  include {
    email = ["reedsut@gmail.com"]
  }
}

resource "cloudflare_zero_trust_access_policy" "talaria_ffilt_us_ci_talaria_ffilt_us_service_token_86d9796d" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.talaria_ffilt_us.id
  name           = "CI talaria.ffilt.us service token"
  decision       = "non_identity"
  precedence     = 1
  include {
    service_token = [local.service_tokens.ci_talaria_ffilt_us] # ci-talaria.ffilt.us
  }
}

resource "cloudflare_zero_trust_access_policy" "talaria_ffilt_us_allow_me_7e96a84e" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.talaria_ffilt_us.id
  name           = "allow_me"
  decision       = "allow"
  precedence     = 2
  include {
    email = ["reedsut@gmail.com"]
  }
}

resource "cloudflare_zero_trust_access_policy" "life_ws_bypass_ca54c055" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.life_ws.id
  name           = "bypass"
  decision       = "bypass"
  precedence     = 1
  include {
    everyone = true
  }
}

resource "cloudflare_zero_trust_access_policy" "wildcard_ffilt_us_agent_stack_494b3100" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.wildcard_ffilt_us.id
  name           = "Agent stack"
  decision       = "non_identity"
  precedence     = 2
  include {
    service_token = [local.service_tokens.agent_stack, local.service_tokens.dashboard_proxy] # Agent-stack, dashboard-proxy
  }
}

resource "cloudflare_zero_trust_access_policy" "wildcard_ffilt_us_home_wan_ip_bypass_6493d0bc" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.wildcard_ffilt_us.id
  name           = "Home WAN IP bypass"
  decision       = "non_identity"
  precedence     = 3
  include {
    ip = ["76.73.229.106/32"]
  }

  # cf-manager rewrites this policy to the current WAN IP every 15m.
  lifecycle {
    ignore_changes = [include, exclude, require]
  }
}

resource "cloudflare_zero_trust_access_policy" "wildcard_ffilt_us_dashboard_proxy_swa_dde5a748" {
  account_id     = var.account_id
  application_id = cloudflare_zero_trust_access_application.wildcard_ffilt_us.id
  name           = "Dashboard proxy (SWA)"
  decision       = "non_identity"
  precedence     = 4
  include {
    service_token = [local.service_tokens.dashboard_proxy_gitea] # dashboard-proxy-gitea
  }
}

resource "cloudflare_zero_trust_access_policy" "warp_login_allow_emails_5_14_2026_ccc15402" {
  account_id       = var.account_id
  application_id   = cloudflare_zero_trust_access_application.warp_login.id
  name             = "Allow emails: 5/14/2026"
  decision         = "allow"
  precedence       = 1
  session_duration = "24h"
  include {
    email = ["reedsut@gmail.com"]
  }
}
