#!/usr/bin/env bash

set -euo pipefail

install_fail2ban() {
    sudo dnf upgrade -y
    sudo dnf install epel-release -y
    sudo dnf install fail2ban -y
}

start_fail2ban() {
    sudo systemctl enable fail2ban.service
    sudo systemctl start fail2ban.service
    sudo systemctl status fail2ban.service
}

main() {
    install_fail2ban
    start_fail2ban
}

main