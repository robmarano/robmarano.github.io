# -----------------------------------------------------------------------------
# ECE 465 Week 13: Bare Metal Provisioning with Terraform
# Description: This Terraform configuration provisions physical Bare Metal 
#              servers (e.g., via Equinix Metal) before any OS is installed.
# -----------------------------------------------------------------------------

terraform {
  required_providers {
    equinix = {
      source = "equinix/equinix"
    }
  }
}

provider "equinix" {
  auth_token = var.metal_auth_token
}

# Provision a cluster of physical machines
resource "equinix_metal_device" "k8s_nodes" {
  count            = 3
  hostname         = "k8s-node-${count.index}"
  plan             = "c3.small.x86"          # Physical Hardware Spec
  metro            = "ny"                    # New York Datacenter
  operating_system = "ubuntu_22_04"          # Tinkerbell/iPXE will burn this OS
  billing_cycle    = "hourly"
  project_id       = var.project_id
}

output "node_ips" {
  value = equinix_metal_device.k8s_nodes[*].access_public_ipv4
}
