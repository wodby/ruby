#!/bin/bash

set -e

docker run --rm --network none --entrypoint /bin/bash -v "$PWD/workspace-runtime.sh:/tmp/workspace-runtime.sh:ro" "${RUBY_IMAGE}" /tmp/workspace-runtime.sh

# Validate the development tool contract before application integration tests.
docker run --rm --network none --entrypoint /bin/sh -v "$PWD/development-tools.sh:/tmp/development-tools.sh:ro" "${RUBY_IMAGE:?must be supplied by make test}" /tmp/development-tools.sh

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

wait_for_cron() {
    executed=0

    for i in $(seq 1 13); do
        if docker_exec crond cat /mnt/files/cron | grep -q "test"; then
            executed=1
            break
        fi
        echo 'Waiting for cron execution...'
        sleep 5
    done

    if [[ "${executed}" -eq '0' ]]; then
        echo >&2 'Cron failed.'
        exit 1
    fi

    echo 'Cron has been executed!'
}

docker_exec() {
    docker compose exec -T "${@}"
}

run_action() {
    docker_exec "${1}" make "${@:2}" -f /usr/local/bin/actions.mk
}

docker compose up -d

run_action ruby check-ready max_try=10 wait_seconds=3

docker_exec ruby tests.sh

wait_for_cron

docker compose down
