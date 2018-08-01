#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

bundle exec unicorn_rails \
    -E {{ getenv "RAILS_ENV" }} \
    -c /usr/local/etc/unicorn/config.rb {{ if (getenv "DEBUG") }}-d{{ end }}
