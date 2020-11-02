pg_ctl -D /usr/local/var/postgres start
bundle exec rake ts:rebuild
bundle exec sidekiq --environment development -C config/sidekiq.yml

