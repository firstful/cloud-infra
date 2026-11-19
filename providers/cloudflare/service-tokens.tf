# Existing Access service tokens — referenced by policy rules, created/rotated by cf-manager.

locals {
  service_tokens = {
    agent_stack           = "122b2ac0-60da-4319-81ef-9db57b888335" # Agent-stack
    ci_apps_ffilt_us      = "b6b2e24d-299b-42e2-bffa-47e1c5961859" # ci-apps.ffilt.us
    ci_jelly_ffilt_us     = "c2d76e28-9b6d-4920-8cd5-83f06e66bd75" # ci-jelly.ffilt.us
    ci_proto_ffilt_us     = "31a1a32d-13fd-41c3-9948-396485c826ba" # ci-proto.ffilt.us
    ci_talaria_ffilt_us   = "fa572822-d214-4c26-9f4a-8e47f431145f" # ci-talaria.ffilt.us
    dashboard_proxy       = "842c0ecd-0972-43fa-8576-8b662ed3dfd9" # dashboard-proxy
    dashboard_proxy_gitea = "d8b0fe00-fe83-4ab1-b03c-7da549db03fc" # dashboard-proxy-gitea
    dev_jellyfin          = "4a9cfc4f-d29c-47b9-ad48-cef5d6a72b6b" # dev-jellyfin
    email_ingest_worker   = "ac6f0ef2-4e88-4834-b01b-af734de01439" # email-ingest-worker
    gitea_github_mirror   = "024aa402-3906-44d9-aad0-4dab9ba44ff4" # gitea-github-mirror
    proto_android         = "afc9e4e6-5927-4d3c-8038-749d866a1134" # proto-android
  }
}
