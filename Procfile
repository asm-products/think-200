web: bundle exec rails s 
resque_standard: env QUEUES=premium,standard TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec rake environment resque:work
