terraform {
  required_version = ">= 1.6"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }

  # State backend: OCI Object Storage (free tier). S3-compatible API.
  # Credentials via AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY env (CI secrets).
  backend "s3" {
    bucket                      = "cloud-infra-tfstate"
    key                         = "oci/terraform.tfstate"
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

provider "oci" {
  # Auth comes from env (set by CI or /home/cloud/.oci):
  #   TF_VAR_tenancy_ocid / TF_VAR_user_ocid / TF_VAR_fingerprint / TF_VAR_private_key_path / TF_VAR_region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
