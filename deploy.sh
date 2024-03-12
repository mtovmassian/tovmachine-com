#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(readlink -f "$0" | xargs dirname)
readonly SCRIPT_DIR

copy_src() {
    sudo cp -rv "${SCRIPT_DIR}/src/"* /var/www/html/
    sudo chcon -R system_u:object_r:httpd_sys_content_t:s0 /var/www/html
}

main() {
    copy_src
}

main