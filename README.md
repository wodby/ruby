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

Use image revision tags such as `wodby/ruby:4-rN` to select a Wodby image revision.
Major and minor tags use the repository release number, starting at `r0`. Full-version tags such as
`wodby/ruby:4.0.7-r0` start at `r0` for each exact upstream version.
Every published versioned revision tag has a matching annotated Git tag pointing to its release commit.
Existing tags remain available after support for their major or minor version ends.
See [release tags](https://github.com/wodby/ruby/tags) for available revisions and the [image revision policy](https://github.com/wodby/images#image-revisions) for upgrade guidance.
Previously published image tags remain available.

About images:

- All images are based on Alpine Linux
- Base image: [ruby](https://github.com/docker-library/ruby)
- [GitHub actions builds](https://github.com/wodby/ruby/actions) 
- [Docker Hub](https://hub.docker.com/r/wodby/ruby) 

Supported tags and respective `Dockerfile` links:

- `4.0`, `4`, `latest` [_(Dockerfile)_]
- `3.4`, `3` [_(Dockerfile)_]
- `3.3` [_(Dockerfile)_]
- `4.0-dev`, `4-dev`, `dev` [_(Dockerfile)_]
- `3.4-dev`, `3-dev` [_(Dockerfile)_]
- `3.3-dev` [_(Dockerfile)_]
- `4.0-dev-macos`, `4-dev-macos` [_(Dockerfile)_]
- `3.4-dev-macos`, `3-dev-macos` [_(Dockerfile)_]
- `3.3-dev-macos` [_(Dockerfile)_]

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

For changes in each image revision, see the [release notes](https://github.com/wodby/ruby/releases).

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

## Building with pinned base images

Build with the Makefile to use the base image digests in `base-images.mk`. Local
builds and CI resolve the same version and variant to the same multi-platform
image. A version without a pin fails before the build starts.

When adding a supported base version or variant, add its image index digest to
`base-images.mk`. For a custom build, override `BASE_IMAGE` with a complete
`repository:tag@sha256:...` reference.

### Development workspace contract

Development variants declare `com.wodby.workspace.contract=1`. Configuration-only
startup (`/docker-entrypoint.sh --configure-runtime`) does not rewrite developer
SSH/Git settings, initialize shared storage, or run application hooks. Normal
startup retains its existing behavior. `WODBY_WORKSPACE=1` selects the workspace
startup command. Login-shell tools remain available when the developer home is mounted.

`workspace-ruby prepare` requires `Gemfile.lock` and runs a frozen Bundler install,
including development dependencies. `workspace-ruby start` runs Puma or the explicit
`WORKSPACE_RUBY_COMMAND`. It sets `RAILS_ENV` and `RACK_ENV` to `development`; `HOST`
and `PORT` default to `0.0.0.0` and `8080`. Generic Ruby requires an application
restart after code changes. Rails applications should configure
`config.file_watcher = ActiveSupport::FileUpdateChecker` in development when using
shared/network storage. A custom evented watcher is not made reliable by placing
pods on the same node. No database migrations or seed commands run automatically.

Dependencies/build output use `.wodby-workspace/` in the shared checkout, excluded
through `.git/info/exclude` without editing `.gitignore`. A tracked directory or
symlink at that reserved path is refused. The runner's private home is not required
by application pods. Package lifecycle scripts remain application-owned and may
modify files; review Git changes after preparation.

CI checks labels for all image variants and runs configuration, developer-state,
reserved-path and runtime tests for development variants. Publish a new image
revision before enabling this contract in a consuming service.
