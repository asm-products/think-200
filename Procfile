web: bundle exec rails s 
resque: env QUEUES=premium,free count=1 VVERBOSE=1 TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec rake environment resque:work
