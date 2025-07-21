set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
# bundle exec rails db:migrate
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:drop db:create db:migrate db:seed
bundle exec rails db:seed