#!/usr/bin/env bash

set -euo pipefail

install_caddy() {
    sudo dnf upgrade -y
    sudo dnf install -y 'dnf-command(copr)'
    sudo dnf copr enable -y @caddy/caddy 
    sudo dnf install -y caddy
}

create_html_dir() {
    sudo mkdir -p /var/www/html
    sudo chcon -R system_u:object_r:httpd_sys_content_t:s0 /var/www
}

create_caddy_log_dir() {
    sudo mkdir -p /var/log/caddy
    sudo chcon -R system_u:object_r:httpd_log_t:s0 /var/log/caddy
}

start_caddy() {
    sudo systemctl enable caddy
    sudo systemctl start caddy
    sudo systemctl status caddy
}

main() {
    install_caddy
    create_html_dir
    create_caddy_log_dir
    start_caddy
}

main