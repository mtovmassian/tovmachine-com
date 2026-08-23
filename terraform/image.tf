# Official Oracle-provided platform image — no marketplace subscription needed,
# works on Trial/Always-Free accounts (unlike third-party Marketplace images, see
# marketplace.tf). This is the default image source.

data "oci_core_images" "platform" {
  compartment_id           = oci_identity_compartment.this.id
  operating_system         = var.platform_os
  operating_system_version = var.platform_os_version
  shape                    = var.instance_shape
  state                    = "AVAILABLE"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

locals {
  platform_image_id = data.oci_core_images.platform.images[0].id
}
