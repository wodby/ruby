#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

ruby -v | grep -q "${RUBY_VERSION}"
