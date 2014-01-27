web: bundle exec rails s 
resque: env VERBOSE=1 INTERVAL=10 QUEUES=premium,free TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec rake environment resque:work
