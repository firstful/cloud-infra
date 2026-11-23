variable "cf_api_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare IaC API token (CI secret CLOUDFLARE_API_TOKEN); see TOKEN.md for exact permissions"
}

variable "account_id" {
  type        = string
  default     = "224469ecf8e8a619106fe8ffa19c7a43"
  description = "Cloudflare zero-trust account"
}
