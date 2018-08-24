# Ruby Docker Container Images

[![Build Status](https://travis-ci.com/wodby/ruby.svg?branch=master)](https://travis-ci.com/wodby/ruby)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/ruby.svg)](https://hub.docker.com/r/wodby/ruby)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/ruby.svg)](https://hub.docker.com/r/wodby/ruby)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/ruby.svg)](https://microbadger.com/images/wodby/ruby)

## Table of Contents

* [Docker Images](#docker-images)
* [Environment Variables](#environment-variables)
* [Build arguments](#build-arguments)    
* [`-dev` images](#-dev-images)
* [`-dev-macos` images](#-dev-macos-images)
* [HTTP server](#http-server)
    * [Unicorn](#unicorn)
    * [Puma](#puma)
* [Crond](#crond)
* [SSHD](#sshd)
* [Adding SSH key](#adding-ssh-key)
* [Users and permissions](#users-and-permissions)
* [Orchestration Actions](#orchestration-actions)

## Docker Images

❗For better reliability we release images with stability tags (`wodby/ruby:3.6-X.X.X`) which correspond to [git tags](https://github.com/wodby/ruby/releases). We strongly recommend using images only with stability tags. 

About images:

* All images are based on Alpine Linux
* [Travis CI builds](https://travis-ci.com/wodby/ruby) 
* [Docker Hub](https://hub.docker.com/r/wodby/ruby) 
* [`-dev`](#-dev-images) and [`-debug`](#-debug-images) images have a few differences

Supported tags and respective `Dockerfile` links:

* `2.5`, `2`, `latest` [_(Dockerfile)_](https://github.com/wodby/ruby/tree/master/Dockerfile)
* `2.4` [_(Dockerfile)_](https://github.com/wodby/ruby/tree/master/Dockerfile)
* `2.3` [_(Dockerfile)_](https://github.com/wodby/ruby/tree/master/Dockerfile)
* `2.5-dev`, `2-dev` [_(Dockerfile)_](https://github.com/wodby/ruby/tree/master/Dockerfile)
* `2.4-dev` [_(Dockerfile)_](https://github.com/wodby/ruby/tree/master/Dockerfile)
* `2.3-dev` [_(Dockerfile)_](https://github.com/wodby/ruby/tree/master/Dockerfile)
* `2.5-dev-macos`, `2-dev-macos` [_(Dockerfile)_](https://github.com/wodby/ruby/tree/master/Dockerfile)
* `2.4-dev-macos` [_(Dockerfile)_](https://github.com/wodby/ruby/tree/master/Dockerfile)
* `2.3-dev-macos` [_(Dockerfile)_](https://github.com/wodby/ruby/tree/master/Dockerfile)

## Environment Variables

| Variable                          | Default value            |
| --------------------------------- | -------------------      |
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
| `UNICORN_GROUP`                   | `www-data`               |
| `UNICORN_PRELOAD_APP`             | `true`                   |
| `UNICORN_RUN_ONCE`                | `true`                   |
| `UNICORN_TIMEOUT`                 | `30`                     |
| `UNICORN_USER`                    | `www-data`               |
| `UNICORN_WORKER_PROCESSES`        | `4`                      |
| `UNICORN_WORKING_DIRECTORY`       | `/usr/src/app`           |

## Build arguments

| Argument         | Default value |
| ---------------- | ------------- |
| `RUBY_DEV`       |               |
| `WODBY_GROUP_ID` | `1000`        |
| `WODBY_USER_ID`  | `1000`        |

Change `WODBY_USER_ID` and `WODBY_GROUP_ID` mainly for local dev version of images, if it matches with existing system user/group ids the latter will be deleted.

## Prebuilt gems with native extensions

| Gem                | Version       |
| ------------------ | ------------- |
| [bcrypt]           | 3.1.12        |
| [bindex]           | 0.5.0         |
| [bootsnap]         | 1.3.1         |
| [bson]             | 4.3.0         |
| [byebug]           | 10.0.2        |
| [eventmachine]     | 1.2.7         |
| [ffi]              | 1.9.25        |
| [hitimes]          | 1.3.0         |
| [http_parser.rb]   | 0.6.0         |
| [jaro_winkler]     | 1.5.1         |
| [kgio]             | 2.11.2        |
| [msgpack]          | 1.2.4         |
| [mysql2]           | 0.5.2         |
| [nio4r]            | 2.3.1         |
| [nokogiri]         | 1.8.4         |
| [nokogumbo]        | 1.5.0         |
| [oj]               | 3.6.6         |
| [pg]               | 1.0.0         |
| [posix-spawn]      | 0.3.13        |
| [puma]             | 3.12.0        |
| [raindrops]        | 0.19.0        |
| [rmagick]          | 2.16.0        |
| [sqlite3]          | 1.3.13        |
| [unf_ext]          | 0.0.7.5       |
| [unicorn]          | 5.4.1         |
| [websocket-driver] | 0.7.0         |

## `-dev` Images

Images with `-dev` tag have the following additions:

* `sudo` allowed for all commands for `wodby` user
* `nodejs` package added
* additional dev gems added 

## `-dev-macos` Images

Same as `-dev` but the default user/group `wodby` has uid/gid `501`/`20`  to match the macOS default user/group ids.

## HTTP server

### Unicorn

Unicorn is the default HTTP server, you can configure it via `UNICORN_` env vars. 

### Puma

To use Puma as your HTTP server override the command to `bundle exec puma -C /usr/local/etc/puma.rb`. You can configure it via `PUMA_` env vars.

## Crond

You can run Crond with this image changing the command to `sudo -E crond -f -d 0` and mounting a crontab file to `./crontab:/etc/crontabs/www-data`. Example crontab file contents:

```
# min	hour	day	month	weekday	command
*/1	*	*	*	*	echo "test" > /mnt/files/cron
```

## SSHD

You can run SSHD with this image by changing the command to `sudo /usr/sbin/sshd -De` and mounting authorized public keys to `/home/wodby/.ssh/authorized_keys`

## Adding SSH key

You can add a private SSH key to the container by mounting it to `/home/wodby/.ssh/id_rsa`

## Users and permissions

Default container user is `wodby:wodby` (UID/GID `1000`). Unicorn runs from `www-data:www-data` user (UID/GID `82`) by default. User `wodby` is a part of `www-data` group.

Codebase volume `$APP_ROOT` (`/usr/src/app`) owned by `wodby:wodby`. Files volume `$FILES_DIR` (`/mnt/files`) owned by `www-data:www-data` with `775` mode.

#### Helper scripts 

* `files_chmod` – in case you need write access for `wodby` user to a file/dir generated by `www-data` on this volume run `sudo files_chmod [FILEPATH]` script (FILEPATH must be under `/mnt/files`), it will recursively change the mode to `ug=rwX,o=rX`

* `files_chown` – in case you manually uploaded files under `wodby` user to files volume and want to change the ownership of those files to `www-data` run `sudo files_chown [FILEPATH]` script (FILEPATH must be under `/mnt/files`), it will recursively change ownership to `www-data:www-data`

## Orchestration Actions

Usage:
```
make COMMAND [params ...]

commands:
    migrate
    check-ready [host max_try wait_seconds delay_seconds]
    files-import source
    files-link public_dir 
```

[bcrypt]: https://rubygems.org/gems/bcrypt
[bindex]: https://rubygems.org/gems/bindex
[bootsnap]: https://rubygems.org/gems/bootsnap
[bson]: https://rubygems.org/gems/bson
[byebug]: https://rubygems.org/gems/byebug
[eventmachine]: https://rubygems.org/gems/eventmachine
[ffi]: https://rubygems.org/gems/ffi
[hitimes]: https://rubygems.org/gems/hitimes
[http_parser.rb]: https://rubygems.org/gems/http_parser.rb
[jaro_winkler]: https://rubygems.org/gems/jaro_winkler
[kgio]: https://rubygems.org/gems/kgio
[msgpack]: https://rubygems.org/gems/msgpack
[mysql2]: https://rubygems.org/gems/mysql2
[nio4r]: https://rubygems.org/gems/nio4r
[nokogiri]: https://rubygems.org/gems/nokogiri
[nokogumbo]: https://rubygems.org/gems/nokogumbo
[oj]: https://rubygems.org/gems/oj
[pg]: https://rubygems.org/gems/pg
[posix-spawn]: https://rubygems.org/gems/posix-spawn
[puma]: https://rubygems.org/gems/puma
[raindrops]: https://rubygems.org/gems/raindrops
[rmagick]: https://rubygems.org/gems/rmagick
[sqlite3]: https://rubygems.org/gems/sqlite3
[unf_ext]: https://rubygems.org/gems/unf_ext
[unicorn]: https://rubygems.org/gems/unicorn
[websocket-driver]: https://rubygems.org/gems/websocket-driver
