# ansible

Ansible playbook that provisions a fresh Oracle Linux host (e.g. the OCI
instance created by `../terraform`) to serve the site with Caddy: opens
http/https in firewalld, installs the Caddy binary and systemd unit, sets up
the `caddy` system user, creates `/etc/caddy`, `/var/www/html` and
`/var/log/caddy` with the right SELinux contexts, and copies
`../caddy/Caddyfile`.

## Usage

```sh
ansible-galaxy collection install -r requirements.yml
ssh-add ~/.ssh/tovmachine-com.key
ansible-playbook playbook.yml
```

The last task also copies `../src` to `/var/www/html`. To re-deploy site content only, without re-running the
firewalld/Caddy install tasks:

```sh
ansible-playbook playbook.yml --tags content
```

## Notes

The Oracle Free Tier VM has very little RAM (Mem: 498Mi / Swap: 944Mi) which can lead to freezing.
In this case reset the VM with 
`oci compute instance action --instance-id ocid1.instance.oc1.eu-paris-1.anrwiljr7y4pqyqcxo4xpr2m7kntcn3cok7mfwr4l3ylrfkdkrbconp42glq --action RESET`.