set -o errexit

bundle install
bundle exec rails assets:clobber
bundle exec rails assets:clean
bundle exec rails assets:precompile
bundle exec rails db:migrate