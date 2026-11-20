terraform {
  required_version = ">= 1.6"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.52"
    }
  }

  # Same free-tier OCI Object Storage bucket as providers/oci, separate state key.
  backend "s3" {
    bucket                      = "cloud-infra-tfstate"
    key                         = "cloudflare/terraform.tfstate"
    region                      = "us-chicago-1"
    endpoint                    = "https://ax7uafe99q6d.compat.objectstorage.us-chicago-1.oraclecloud.com"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

provider "cloudflare" {
  api_token = var.cf_api_token
}
