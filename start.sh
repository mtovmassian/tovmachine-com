#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(readlink -f "$0" | xargs dirname)
readonly SCRIPT_DIR
readonly STACKNAME="tovmachine-com"

docker_compose_pull() {
    docker compose \
        -f "${SCRIPT_DIR}/docker-compose.yml" \
        pull
}

docker_compose_up() {
    docker compose \
        -f "${SCRIPT_DIR}/docker-compose.yml" \
        -p $STACKNAME \
        up \
        --detach \
        --build
}

docker_exec() {
    docker exec -it "${STACKNAME}-caddy" "$@"
}

main() {
    
    docker_compose_pull
    docker_compose_up

    set +u
    exec_opt="$1"
    set -u
    { [[ "$exec_opt" == "exec" ]] && shift && docker_exec "$@"; } || :
}

main "$@"