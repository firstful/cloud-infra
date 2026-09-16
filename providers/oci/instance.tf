# Always-Free instance — the WireGuard hub / backup target / probe vantage
# (plan of record 2026-09: A1.Flex 2 OCPU / 12 GB, Ubuntu 22.04, ~200 GB boot).
#
# SPEND GATE: A1.Flex OCPU+RAM is Always-Free up to 4 OCPU/24GB total; boot
# volume ≤200GB total block storage is free. `tofu plan` must show only
# Always-Free-eligible resources or the apply is aborted by CI.

locals {
  # Canonical image OCID for Ubuntu 22.04 — resolve dynamically so the OCID
  # never goes stale in-repo.
  ubuntu_2204 = data.oci_core_images.ubuntu.images[0].id
}

data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-22\\.04.*$"]
    regex  = true
  }
}

resource "oci_core_instance" "hub" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid

  shape = "VM.Standard.A1.Flex"
  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }

  source_details {
    source_type             = "image"
    source_id               = local.ubuntu_2204
    boot_volume_size_in_gbs = 50 # start at 50 of the 200GB block allowance
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    display_name     = "hub-vnic"
    assign_public_ip = true
    hostname_label   = "hub"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  display_name = "wireguard-hub"

  # Cost guard: fail loudly if the shape ever drifts off Always-Free.
  # Static constants today; if shape becomes a variable, reference it here.
  lifecycle {
    precondition {
      condition     = var.ocpus <= 4 && var.memory_in_gbs <= 24
      error_message = "SPEND GATE: A1.Flex exceeds Always-Free allowance (4 OCPU / 24 GB total)."
    }
  }
}

variable "availability_domain" {
  type        = string
  description = "Target AD (set per-region; AD-3 was out of capacity 2026-09)"
}

variable "ocpus" {
  type        = number
  description = "A1.Flex OCPUs (Always-Free cap: 4 total across tenancy)"
  default     = 2
}

variable "memory_in_gbs" {
  type        = number
  description = "A1.Flex RAM GB (Always-Free cap: 24 total across tenancy)"
  default     = 12
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the default ubuntu user"
}

output "instance_public_ip" {
  value = oci_core_instance.hub.public_ip
}
