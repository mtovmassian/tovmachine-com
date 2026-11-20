# AGENTS.md

Guidance for AI coding agents working in this repository.

## Project overview

`tovmachine-com` is the source of [tovmachine.com](https://tovmachine.com), a minimal
professional portfolio site for Martin Tovmassian (DevOps engineer). It is a static
site served by [Caddy](https://caddyserver.com/), hosted on an Oracle Cloud Always
Free VM running Oracle Linux, and fronted by Cloudflare.

The repo holds the site content and everything needed to run it: the infra
(Terraform), the host provisioning and deployment (Ansible), and a local Docker
setup.

## Repository layout

| Path | Purpose |
| --- | --- |
| `src/` | Site content, served as-is from `/var/www/html` |
| `src/index.html`, `src/style.css` | Home page: stack, resume link, social links |
| `src/resume/` | Resume PDF linked from the home page |
| `src/enjoy/` | "Col du Lautaret" real-time view: canvas animation of the latest Skaping webcam picture, fetched through the `scapin` Netlify function |
| `caddy/Caddyfile` | Caddy config, shared by the Docker setup and production |
| `caddy/Dockerfile` | Rocky Linux 9 + Caddy image for local runs |
| `docker-compose.yml`, `start.sh`, `stop.sh` | Local run on `127.0.0.1:80` |
| `terraform/` | OCI infra: compartment, VCN, `VM.Standard.E2.1.Micro` instance (see `terraform/README.md`) |
| `ansible/` | Provisions the VM (firewalld, Caddy binary + systemd unit, SELinux contexts) and deploys `src/` (see `ansible/README.md`) |
| `markdown-resume/` | Git submodule (fork of junian/markdown-resume) used to write the resume; the exported PDF is copied to `src/resume/` |

## Site content conventions

- Plain HTML/CSS/vanilla JS only. No framework, no build step, no bundler, no npm
  dependency in `src/`.
- Pages are processed by Caddy's `templates` directive (e.g.
  `{{now | date "2006"}}` in footers). Keep template syntax valid; it is rendered
  server-side, so opening a file directly in a browser shows it raw.
- Icons are inline SVGs from Iconify (`mdi:*`), with an `<!--Iconify mdi:name-->`
  comment above each one. Do not add icon fonts or external icon CDNs.
- Every page includes the favicon and the shared footer.
- Keep the site light: the production VM has ~500 MiB of RAM.

## Running locally

```sh
./start.sh            # build and start Caddy in Docker, http://127.0.0.1
./start.sh exec bash  # same, then exec into the container
./stop.sh
```

`src/` and the `Caddyfile` are bind-mounted read-only, so content edits show up
without a rebuild. Caddyfile changes need a container restart.

## Infra and deployment

- Terraform: `cd terraform && terraform init && terraform plan`. Never commit
  `terraform.tfvars` or state files (already in `.gitignore`).
- Ansible: full provisioning with `ansible-playbook playbook.yml`; content-only
  redeploy with `ansible-playbook playbook.yml --tags content` (run from
  `ansible/`).
- The Caddyfile is the single source of truth for both local and production.
  Changes to it must work in both contexts.
- Production runs SELinux in enforcing mode: any new directory Caddy reads or
  writes needs the right `sefcontext` + `restorecon` in the playbook.
- Do not run `terraform apply`, `ansible-playbook` or any command that touches the
  production VM unless explicitly asked. Prefer `terraform plan` and
  `ansible-playbook --check --diff` to show the effect of a change.

## Submodule

`markdown-resume/` is a separate repository (pnpm/Nuxt). Do not edit it from this
repo unless asked; changes there are committed in the submodule first, then the
submodule pointer is updated here.

## Commits

- Short, lowercase, imperative-ish messages describing the change, e.g.
  `replace setup/deploy scripts with ansible playbook`. Older commits use gitmoji
  with a scope (`:bug: (lautaret) ...`); either style is accepted, stay consistent
  within a change.
- One logical change per commit.
- Do not add a Co-Authored-By trailer to commit messages.
- Commit or push only when asked.
