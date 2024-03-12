#!/usr/bin/env bash

set -euo pipefail

install_bash_completion() {
    sudo dnf upgrade -y
    sudo dnf install bash-completion
}

main() {
    install_bash_completion
}

main