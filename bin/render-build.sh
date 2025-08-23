#!/usr/bin/env bash
set -o errexit
set -o pipefail

# 1) Bundler を最小構成で（dev/test は除外）
bundle config set without 'development test'
bundle install --jobs 4 --retry 3

# 2) フロント依存がある場合のみインストール（ロックファイル検出で自動）
if [ -f bun.lockb ] && command -v bun >/dev/null 2>&1; then
  # bun を使っているプロジェクトなら（※ bun の再インストールは絶対しない）
  bun install --no-save
elif [ -f package-lock.json ]; then
  npm ci --omit=dev
elif [ -f yarn.lock ]; then
  yarn install --frozen-lockfile --production
fi

# 3) アセットをビルド（API-onlyならコメントアウトしてOK）
bundle exec rails assets:precompile

# 4) Render 側が触れない想定なので、ここで migrate までやる
#    （長いマイグレーションがあると Deploy が長くなる点だけ留意）
bundle exec rails db:migrate
