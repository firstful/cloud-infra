variable "cf_api_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare API token with Access: Apps and Policies Read/Write (CI secret CLOUDFLARE_API_TOKEN)"
}

variable "account_id" {
  type        = string
  default     = "224469ecf8e8a619106fe8ffa19c7a43"
  description = "Cloudflare zero-trust account"
}
