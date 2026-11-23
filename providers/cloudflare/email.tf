# Email stack: R2 raw store -> Worker -> Queue, plus Email Routing rule.
# R2 lifecycle rules are not exposed by cloudflare/cloudflare v4 and remain
# outside IaC (tracked in docs/CLOUDFLARE-INVENTORY.md).

resource "cloudflare_r2_bucket" "email_raw" {
  account_id = var.account_id
  name       = "ffilt-us-email-raw"
}

resource "cloudflare_queue" "email_ingest" {
  account_id = var.account_id
  name       = "email-ingest-queue"
}

resource "cloudflare_workers_script" "email_ingest" {
  account_id = var.account_id
  name       = "email-ingest"
  content    = file("${path.module}/files/email-ingest/worker.js")

  r2_bucket_binding {
    name        = "RAW_BUCKET"
    bucket_name = cloudflare_r2_bucket.email_raw.name
  }
  queue_binding {
    binding = "EMAIL_QUEUE"
    queue   = cloudflare_queue.email_ingest.name
  }
}

resource "cloudflare_email_routing_rule" "catch_all_ingest" {
  zone_id  = local.zones["ffilt.us"]
  name     = "catch-all -> ingest worker (store all, no forward)"
  enabled  = true
  priority = 2147483647

  matcher {
    type = "all"
  }
  action {
    type  = "worker"
    value = [cloudflare_workers_script.email_ingest.name]
  }
}
