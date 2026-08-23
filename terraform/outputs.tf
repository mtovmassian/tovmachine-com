output "instance_id" {
  description = "OCID of the created compute instance."
  value       = oci_core_instance.this.id
}

output "public_ip" {
  description = "Public IP address of the instance."
  value       = oci_core_instance.this.public_ip
}

output "ssh_command" {
  description = "Convenience SSH command. Oracle Linux images use the \"opc\" user; if you switch to the Rocky Linux marketplace image, use \"rocky\" instead."
  value       = "ssh opc@${oci_core_instance.this.public_ip}"
}
