#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(readlink -f "$0" | xargs dirname)
readonly SCRIPT_DIR
readonly STACKNAME="tovmachine-com"

docker_compose_stop() {
    docker compose \
        -f "${SCRIPT_DIR}/docker-compose.yml" \
        -p "$STACKNAME" \
        stop
}

main() {
    docker_compose_stop
}

main "$@"