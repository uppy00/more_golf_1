#!/usr/bin/env bash
set -o errexit

# bun install
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

bundle install
bundle exec rails assets:precompile
bundle exec rails db:migrate

