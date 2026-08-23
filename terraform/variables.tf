# --- Auth / OCI CLI config (~/.oci/config) ---

variable "oci_config_profile" {
  description = "Profile name in ~/.oci/config (as set up by `oci setup config`)."
  type        = string
  default     = "DEFAULT"
}

variable "region" {
  description = "OCI region to deploy into, e.g. \"eu-paris-1\", \"us-ashburn-1\"."
  type        = string
}

variable "tenancy_ocid" {
  description = "Tenancy OCID (same value as `tenancy` in ~/.oci/config)."
  type        = string
}

variable "compartment_name" {
  description = "Name of the dedicated compartment created to hold all resources in this stack."
  type        = string
  default     = "tovmachine"
}

variable "compartment_description" {
  description = "Description for the dedicated compartment."
  type        = string
  default     = "tovmachine.com infra"
}

# --- Access ---

variable "ssh_public_key_path" {
  description = "Path to the SSH public key that will be injected into the instance's opc user."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to reach the instance over SSH (port 22). Restrict this to your own IP/32 in production."
  type        = string
  default     = "0.0.0.0/0"
}

# --- Compute ---

variable "instance_display_name" {
  description = "Display name for the compute instance."
  type        = string
  default     = "tovmachine-com"
}

variable "instance_shape" {
  description = "Always Free eligible shape. VM.Standard.E2.1.Micro is a fixed AMD shape (1/8 OCPU, 1GB RAM, x86_64) and needs no shape_config."
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "boot_volume_size_in_gbs" {
  description = "Boot volume size in GB. The Always Free tier includes up to 200GB of total block storage across both free VMs."
  type        = number
  default     = 50
}

variable "availability_domain_number" {
  description = "Index (1-based) of the availability domain to use, as returned by the tenancy's AD list."
  type        = number
  default     = 1
}

# --- Image ---
#
# An official Oracle-provided platform image (image.tf), resolved automatically by
# OS/version/shape. No subscription needed, works on Trial/Always-Free accounts —
# unlike third-party Marketplace images (e.g. Rocky Linux), which are gated behind a
# Marketplace agreement that Trial/Always-Free accounts can't actually obtain
# (LaunchInstance 404s even after a Terraform-created subscription succeeds).

variable "platform_os" {
  description = "Operating system for the default platform image lookup (image.tf)."
  type        = string
  default     = "Oracle Linux"
}

variable "platform_os_version" {
  description = "Operating system version for the default platform image lookup (image.tf)."
  type        = string
  default     = "9"
}

variable "image_id" {
  description = "OCID of a specific image to boot from, overriding the default platform image lookup. Leave empty to use the platform image."
  type        = string
  default     = ""
}
