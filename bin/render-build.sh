#!/usr/bin/env bash
set -o errexit

bundle install
yarn install

# JS と CSS をビルド
yarn build
yarn build:css

# Rails アセットプリコンパイル
bundle exec rails assets:precompile
bundle exec rails db:migrate
