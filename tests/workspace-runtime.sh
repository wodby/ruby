#!/usr/bin/env bash
# Run inside the image with the normal entrypoint bypassed.
set -euo pipefail
fixture=$(mktemp -d)
fixture=$(cd "$fixture" && pwd -P)
trap 'rm -rf "$fixture"' EXIT
mkdir -p "$fixture/repo" "$fixture/home/.ssh" "$fixture/tools"
export APP_ROOT="$fixture/repo" HOME="$fixture/home"
printf 'Host saved\n' > "$HOME/.ssh/config"
printf '[user]\n  name = Developer\n' > "$HOME/.gitconfig"
cp "$HOME/.ssh/config" "$fixture/ssh.expected"
cp "$HOME/.gitconfig" "$fixture/git.expected"
# Configuration succeeds repeatedly without running storage/init or identity setup.
/docker-entrypoint.sh --configure-runtime
/docker-entrypoint.sh --configure-runtime
cmp "$HOME/.ssh/config" "$fixture/ssh.expected"
cmp "$HOME/.gitconfig" "$fixture/git.expected"
bash -lc 'command -v bundle' >/dev/null
cd "$APP_ROOT"
git init -q
printf 'tracked\n' > source.txt
git add source.txt
workspace-path > "$fixture/path"
test "$(cat "$fixture/path")" = "$APP_ROOT/.wodby-workspace"
test -z "$(git ls-files --others --exclude-standard)"
# A tracked collision is refused, even when local exclude rules hide new files.
printf collision > .wodby-workspace/collision
git add -f .wodby-workspace/collision
if workspace-path; then echo 'accepted tracked runtime storage' >&2; exit 1; fi
git rm -q --cached .wodby-workspace/collision
rm .wodby-workspace/collision
export PATH="$fixture/tools:$PATH"
if workspace-ruby prepare; then echo 'accepted missing lockfile' >&2; exit 1; fi
printf lock > Gemfile.lock
cat > "$fixture/tools/bundle" <<'SH'
#!/bin/sh
[ "$*" = install ]
[ "$BUNDLE_FROZEN" = true ]
[ "$BUNDLE_PATH" = "$APP_ROOT/.wodby-workspace/bundle" ]
[ -z "$BUNDLE_WITHOUT" ]
SH
chmod +x "$fixture/tools/bundle"
workspace-ruby prepare
test "$(cat Gemfile.lock)" = lock
WORKSPACE_RUBY_COMMAND='test "$RAILS_ENV" = development; test "$PORT" = 8080' WODBY_WORKSPACE=1 /docker-entrypoint.sh ignored
cmp "$HOME/.ssh/config" "$fixture/ssh.expected"
cmp "$HOME/.gitconfig" "$fixture/git.expected"
echo 'Workspace runtime checks passed'
