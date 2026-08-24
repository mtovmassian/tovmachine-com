#!/usr/bin/env bash

set -euo pipefail

readonly CADDY_VERSION="2.11.4"
readonly CADDY_ARCHIVE="caddy_${CADDY_VERSION}_linux_amd64.tar.gz"

add_firewall_http_https_service() {
    sudo firewall-cmd --zone=public --permanent --add-service=http --add-service=https
    sudo firewall-cmd --reload
}

install_caddy_executable() {
    sudo rm -f "$CADDY_ARCHIVE"
    sudo curl -L "https://github.com/caddyserver/caddy/releases/download/v${CADDY_VERSION}/${CADDY_ARCHIVE}" -OJ
    sudo tar xzvf caddy_2.11.4_linux_amd64.tar.gz caddy
    sudo install caddy /usr/bin/caddy
}

create_caddy_system_user() {
    if ! id caddy; then
    	sudo useradd --system --home-dir /var/lib/caddy --shell /usr/sbin/nologin caddy
    else
	    echo "System user caddy already exists"
    fi
}

create_caddy_dirs() {
    sudo mkdir -p /etc/caddy
    
    sudo mkdir -p /var/www/html
    sudo semanage fcontext -a -t httpd_sys_content_t "/var/www(/.*)?"
    sudo restorecon -Rv /var/www

    sudo mkdir -p /var/log/caddy
    sudo chown -R caddy:caddy /var/log/caddy
    sudo semanage fcontext -a -t httpd_log_t "/var/log/caddy(/.*)?"
    sudo restorecon -Rv /var/log/caddy
}

copy_caddy_conf() {
    sudo cp ../caddy/Caddyfile /etc/caddy
}

install_caddy_systemd_service_unit() {
    cat << 'EOF' | sudo tee /usr/lib/systemd/system/caddy.service
# caddy.service
#
# For using Caddy with a config file.
#
# Make sure the ExecStart and ExecReload commands are correct
# for your installation.
#
# See https://caddyserver.com/docs/install for instructions.
#
# WARNING: This service does not use the --resume flag, so if you
# use the API to make changes, they will be overwritten by the
# Caddyfile next time the service is restarted. If you intend to
# use Caddy's API to configure it, add the --resume flag to the
# `caddy run` command or use the caddy-api.service file instead.

[Unit]
Description=Caddy
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=notify
User=caddy
Group=caddy
ExecStart=/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile --force
TimeoutStopSec=5s
LimitNOFILE=1048576
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable --now caddy
}

start_caddy() {
    sudo systemctl start caddy
    sudo systemctl status caddy
}

main() {
    add_firewall_http_https_service
    install_caddy_executable
    create_caddy_system_user
    create_caddy_dirs
    copy_caddy_conf
    install_caddy_systemd_service_unit
    start_caddy
}

main
