web: env bundle exec rails s
resque_standard: env INTERVAL=0.5 QUEUES=premium,standard TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec rake environment resque:work
