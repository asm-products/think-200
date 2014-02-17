web: bundle exec rails s 
resque_premium: env QUEUES=premium COUNT=5 TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 VVERBOSE=1 bundle exec rake environment resque:workers
resque_standard: env QUEUES=premium,standard TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 VVERBOSE=1 bundle exec rake environment resque:work
