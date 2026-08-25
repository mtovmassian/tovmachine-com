# Oracle Cloud — VM Always Free

Provisions a dedicated compartment, one Always Free `VM.Standard.E2.1.Micro` instance
with a public IP, in its own VCN with ports 22/80/443 open. This is infra only — it
does **not** install Caddy/firewalld on the box; run the `../ansible/playbook.yml`
playbook once the instance is up.

## Prerequisites

1. Terraform >= 1.5.
2. OCI CLI configured locally: `oci setup config` (creates `~/.oci/config` and an
   API signing key). You'll need an existing OCI account with the Always Free tier.
3. An SSH keypair (defaults to `~/.ssh/id_rsa.pub`).

## Usage

```sh
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: region, tenancy_ocid, ssh_allowed_cidr

terraform init
terraform plan
terraform apply
```

Once applied:

```sh
terraform output ssh_command
```
