#!/usr/bin/env bash

##############################################################
# vagrant-provision.sh
#
# Rails 4.1.0 on Ubuntu 12.04.4
##############################################################


#
# Execute a command as the vagrant user.
# Otherwise, commands are executed as root.
#
function v() {
  # NB: This executes the vagrant .profile.
  su - -c "$1" vagrant
}


#
# Set up Ubuntu
#
export LC_ALL=en_US.UTF-8  # Set the locale correctly
export LC_CTYPE=$LC_ALL
export LANG=$LC_ALL
export LANGUAGE=$LC_ALL
export TZ=America/Los_Angeles
export DEBIAN_FRONTEND=noninteractive
# echo 'ubuntu' > /etc/hostname
# echo '127.0.0.1 ubuntu' > /etc/hosts
# hostname ubuntu

# Updated Postgres Repository
echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

aptitude -q -y update
aptitude -q -y install curl git libpq-dev locales nodejs postgresql-9.3 vim 

#
# RVM and Ruby 2.1.1
#
v "echo 'gem: --no-rdoc --no-ri' > /home/vagrant/.gemrc"
v "curl -L https://get.rvm.io | bash"
v "source ~/.rvm/scripts/rvm" 
v "rvm install 2.1.1" 
v "rvm rvmrc warning ignore allGemfiles"
v "gem update --system; gem update" 

#
# Set up the app
#
v "cd /vagrant; bundle install && rake db:setup && rspec"
