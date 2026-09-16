variable "tenancy_ocid" {
  type        = string
  description = "OCI tenancy OCID"
}

variable "user_ocid" {
  type        = string
  description = "OCI user OCID for API signing"
}

variable "fingerprint" {
  type        = string
  description = "Fingerprint of the API signing key"
}

variable "private_key_path" {
  type        = string
  description = "Path to the API signing private key (never in-repo)"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "OCI region"
  default     = "us-chicago-1"
}

variable "compartment_ocid" {
  type        = string
  description = "Compartment to provision into (root compartment until a dedicated one exists)"
}
