#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

sudo apk add --update yaml-dev
ruby -v | grep -q "${RUBY_VERSION}"

ssh sshd cat /home/wodby/.ssh/authorized_keys | grep -q admin@example.com

curl -s nginx | grep -q "Rails version:"
curl -s localhost:8080 | grep -q "Rails version:"