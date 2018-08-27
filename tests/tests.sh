#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

ruby -v | grep -q "${RUBY_VERSION}"

ssh sshd cat /home/wodby/.ssh/authorized_keys | grep -q admin@example.com

curl -s nginx | grep -q "Yay! You&rsquo;re on Rails!"
curl -s localhost:8080 | grep -q "Yay! You&rsquo;re on Rails!"