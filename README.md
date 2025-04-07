# Ruby Docker Container Images

[![Build Status](https://github.com/wodby/ruby/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/ruby/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/ruby.svg)](https://hub.docker.com/r/wodby/ruby)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/ruby.svg)](https://hub.docker.com/r/wodby/ruby)

## Table of Contents

- [Docker Images](#docker-images)
    - [`-dev`](#-dev)
    - [`-dev-macos`](#-dev-macos)
    - [Supported architectures](#supported-architectures)
- [Environment Variables](#environment-variables)
- [Build arguments](#build-arguments)
- [Changelog](#changelog)
- [Gems](#gems)
- [HTTP server](#http-server)
    - [Puma (default)](#puma)
    - [Unicorn](#unicorn)
- [Crond](#crond)
- [SSHD](#sshd)
- [Adding SSH key](#adding-ssh-key)
- [Complete Ruby stack](#complete-ruby-stack)
- [Orchestration Actions](#orchestration-actions)

## Docker Images

❗For better reliability we release images with stability tags (`wodby/ruby:3-X.X.X`) which correspond to [git tags](https://github.com/wodby/ruby/releases). We strongly recommend using images only with stability tags.

About images:

- All images based on Alpine Linux
- Base image: [ruby](https://github.com/docker-library/ruby)
- [GitHub actions builds](https://github.com/wodby/ruby/actions) 
- [Docker Hub](https://hub.docker.com/r/wodby/ruby) 

Supported tags and respective `Dockerfile` links:

- `3.4`, `3`, `latest` [_(Dockerfile)_]
- `3.3` [_(Dockerfile)_]
- `3.2` [_(Dockerfile)_]
- `3.4-dev`, `3-dev`, `dev` [_(Dockerfile)_]
- `3.3-dev` [_(Dockerfile)_]
- `3.2-dev` [_(Dockerfile)_]
- `3.4-dev-macos`, `3-dev-macos` [_(Dockerfile)_]
- `3.3-dev-macos` [_(Dockerfile)_]
- `3.2-dev-macos` [_(Dockerfile)_]

[_(Dockerfile)_]: https://github.com/wodby/ruby/tree/master/Dockerfile

### `-dev` 

Images with `-dev` tag have the following additions:

- `sudo` allowed for all commands for `wodby` user
- dev package added for additional native extensions compilation 
- `nodejs` package added (required by rails)

### `-dev-macos`

Same as `-dev` but the default user/group `wodby` has uid/gid `501`/`20`  to match the macOS default user/group ids.

### Supported architectures

All images built for `linux/amd64`, `-dev-macos` images additionally built for `linux/arm64`

## Environment Variables

| Variable                          | Default value            |
|-----------------------------------|--------------------------|
| `GIT_USER_EMAIL`                  | `wodby@example.com`      |
| `GIT_USER_NAME`                   | `wodby`                  |
| `PUMA_DIRECTORY`                  | `/usr/src/app`           |
| `PUMA_ENVIRONMENT`                | `development`            |
| `PUMA_PRELOAD_APP`                |                          |
| `PUMA_PRUNE_BUNDLER`              |                          |
| `PUMA_QUIET`                      |                          |
| `PUMA_RACKUP`                     | `/usr/src/app/config.ru` |
| `PUMA_TAG`                        |                          |
| `PUMA_THREADS`                    | `0, 16`                  |
| `PUMA_WORKER_BOOT_TIMEOUT`        | `60`                     |
| `PUMA_WORKER_TIMEOUT`             | `60`                     |
| `PUMA_WORKERS`                    | `2`                      |
| `RAILS_ENV`                       | `development`            |
| `SSH_DISABLE_STRICT_KEY_CHECKING` |                          |
| `SSH_PRIVATE_KEY`                 |                          |
| `SSHD_GATEWAY_PORTS`              | `no`                     |
| `SSHD_HOST_KEYS_DIR`              | `/etc/ssh`               |
| `SSHD_LOG_LEVEL`                  | `INFO`                   |
| `SSHD_PASSWORD_AUTHENTICATION`    | `no`                     |
| `SSHD_PERMIT_USER_ENV`            | `no`                     |
| `SSHD_USE_DNS`                    | `yes`                    |
| `UNICORN_CHECK_CLIENT_CONNECTION` | `false`                  |
| `UNICORN_DEBUG`                   |                          |
| `UNICORN_PRELOAD_APP`             | `true`                   |
| `UNICORN_RUN_ONCE`                | `true`                   |
| `UNICORN_TIMEOUT`                 | `30`                     |
| `UNICORN_WORKER_PROCESSES`        | `4`                      |
| `UNICORN_WORKING_DIRECTORY`       | `/usr/src/app`           |

## Build arguments

| Argument         | Default value |
|------------------|---------------|
| `RUBY_DEV`       |               |
| `WODBY_GROUP_ID` | `1000`        |
| `WODBY_USER_ID`  | `1000`        |

Change `WODBY_USER_ID` and `WODBY_GROUP_ID` mainly for local dev version of images, if it matches with existing system user/group ids the latter will be deleted.

## Changelog

Changes per stability tag reflected in git tags description under [releases](https://github.com/wodby/ruby/releases). 

## Gems

To install gems with native extensions use `-dev` image variants that contain required dev packages.

## HTTP server

### Puma

Puma is the default HTTP server, you can configure it via `PUMA_` env vars. 

### Unicorn

To use Unicorn as your HTTP server override the default container command to `/etc/init.d/unicorn`. You can configure it via `UNICORN_` env vars. 

## Crond

You can run Crond with this image changing the command to `sudo -E crond -f -d 0` and mounting a crontab file to `./crontab:/etc/crontabs/wodby`. Example crontab file contents:

```
# min	hour	day	month	weekday	command
*/1	*	*	*	*	echo "test" > /mnt/files/cron
```

## SSHD

You can run SSHD with this image by changing the command to `sudo /usr/sbin/sshd -De` and mounting authorized public keys to `/home/wodby/.ssh/authorized_keys`

## Adding SSH key

You can add a private SSH key to the container by mounting it to `/home/wodby/.ssh/id_rsa`

## Complete Ruby stack

See https://github.com/wodby/docker4ruby

## Orchestration Actions

Usage:
```
make COMMAND [params ...]

commands:
    check-ready [host max_try wait_seconds delay_seconds]
    files-import source
    files-link public_dir 
```
