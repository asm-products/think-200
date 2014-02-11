web: bundle exec rails s 
resque: env QUEUES=premium,standard COUNT=3 TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 VVERBOSE=1 bundle exec rake environment resque:workers
