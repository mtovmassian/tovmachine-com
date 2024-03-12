#!/usr/bin/env bash

set -euo pipefail

install_firewalld() {
    sudo dnf upgrade -y
    sudo dnf install firewalld -y
}

start_firewalld() {
    sudo systemctl enable firewalld
    sudo systemctl start firewalld
    sudo systemctl status firewalld
}

add_http_service() {
    sudo firewall-cmd --zone=public --add-service=http
    sudo firewall-cmd reload
}

add_https_service() {
    sudo firewall-cmd --zone=public --add-service=https
    sudo firewall-cmd reload
}

main() {
    install_firewalld
    start_firewalld
    add_http_service
    add_https_service
}

main