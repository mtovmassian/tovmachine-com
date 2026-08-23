data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

locals {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain_number - 1].name

  resolved_image_id = var.image_id != "" ? var.image_id : local.platform_image_id

  ssh_public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "oci_core_instance" "this" {
  compartment_id      = oci_identity_compartment.this.id
  availability_domain = local.availability_domain
  display_name        = var.instance_display_name
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    assign_public_ip = true
    display_name     = "${var.instance_display_name}-vnic"
  }

  source_details {
    source_type             = "image"
    source_id               = local.resolved_image_id
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  metadata = {
    ssh_authorized_keys = local.ssh_public_key
  }
}
