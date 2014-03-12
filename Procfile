web: env TRUSTED_IP=67.168.204.53 bundle exec rails s --port=8997
resque_standard: env QUEUES=premium,standard TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec rake environment resque:work
