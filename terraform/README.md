# Oracle Cloud — VM Always Free

Provisions a dedicated compartment, one Always Free `VM.Standard.E2.1.Micro` instance
with a public IP, in its own VCN with ports 22/80/443 open. This is infra only — it
does **not** install Caddy/firewalld/fail2ban on the box; run the existing scripts in
`../rocky-linux/` over SSH once the instance is up, same as before (they're
RHEL-family scripts — dnf/firewalld/SELinux/copr — and work unchanged on Oracle Linux).

Defaults to **Oracle Linux 9** (`image.tf`), not Rocky Linux. On a Trial/Always-Free
tenancy (no billing method on file), third-party Marketplace images — including Rocky
Linux, published by CIQ — are not actually launchable: `terraform apply` will create
the Marketplace subscription object without error, but `LaunchInstance` then fails with
a `404 NotAuthorizedOrNotFound`, and the Marketplace listing page itself refuses to load
in the Console with the same error. Oracle Linux is functionally equivalent for this
setup (RHEL-family, dnf/firewalld/SELinux) and isn't gated this way.

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

Then SSH in and run the setup scripts, e.g.:

```sh
scp -r ../rocky-linux opc@<public_ip>:~/
ssh opc@<public_ip>
./rocky-linux/install-firewalld.sh
./rocky-linux/install-caddy.sh
./rocky-linux/install-fail2ban.sh
```

## Notes / gotchas

- **Free tier limits**: 2 AMD micro VMs + 200GB total block storage per tenancy, per
  region where Always Free is enabled. This config uses 1 VM and defaults to a 50GB
  boot volume (`boot_volume_size_in_gbs`).
- **Compartment**: `compartment.tf` creates a dedicated compartment (`compartment_name`,
  default `tovmachine`) under the tenancy root — everything else is created inside it.
- **SSH exposure**: `ssh_allowed_cidr` defaults to `0.0.0.0/0`. Set it to your own
  `IP/32` before applying if you don't want SSH open to the internet.
- **Ephemeral public IP**: the public IP is ephemeral, tied to the instance's VNIC —
  it stays stable across reboots but changes if the instance is recreated (e.g. shape
  change). Point DNS accordingly, or add a reserved public IP resource if you need a
  fixed address across recreations.
