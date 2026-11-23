# One-time adoption for the resources beyond Access. Import IDs follow the
# cloudflare provider's <account_id|zone_id>/<resource id|name> convention.

import {
  to = cloudflare_zero_trust_tunnel_cloudflared_config.ffiltus
  id = "224469ecf8e8a619106fe8ffa19c7a43/8f3e5dfe-4a19-4b58-8ca7-f2924735876b"
}

import {
  to = cloudflare_workers_script.email_ingest
  id = "224469ecf8e8a619106fe8ffa19c7a43/email-ingest"
}

import {
  to = cloudflare_r2_bucket.email_raw
  id = "224469ecf8e8a619106fe8ffa19c7a43/ffilt-us-email-raw"
}

import {
  to = cloudflare_queue.email_ingest
  id = "224469ecf8e8a619106fe8ffa19c7a43/c2435a66416048258d583d59879389fe"
}

import {
  to = cloudflare_email_routing_rule.catch_all_ingest
  id = "b36262ee7b94037531e8f833a408a7df/b15876b8cc064a4989322a1ac637d0c2"
}
