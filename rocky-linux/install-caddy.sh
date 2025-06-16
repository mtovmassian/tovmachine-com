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
    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www(/.*)?"
    sudo restorecon -Rv /var/www
}

create_caddy_log_dir() {
    sudo mkdir -p /var/log/caddy
    sudo chown -R caddy:caddy /var/log/caddy
    sudo semanage fcontext -a -t httpd_log_t "/var/log/caddy(/.*)?"
    sudo restorecon -Rv /var/log/caddy
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
