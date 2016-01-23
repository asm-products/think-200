#!/usr/bin/env bash

##############################################################
# vagrant-provision.sh
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
echo 'LC_ALL="en_US.UTF-8"' > /etc/default/locale
export LC_CTYPE=$LC_ALL
export LANG=$LC_ALL
export LANGUAGE=$LC_ALL
export TZ=America/Los_Angeles
export DEBIAN_FRONTEND=noninteractive
aptitude -q -y update
aptitude -q -y install curl git locales nodejs python-software-properties \
                       redis-server software-properties-common vim

# Postgres 9.3
echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
aptitude -q -y update
aptitude -q -y install libpq-dev postgresql-9.3

#
# RVM and Ruby
#
echo 'gem: --no-rdoc --no-ri' > /home/vagrant/.gemrc
echo '--color' > /home/vagrant/.rspec
v "curl -L https://get.rvm.io | bash"
v "source ~/.rvm/scripts/rvm"
v "rvm install 2.1.5"
cp /vagrant/script/after_use_spring_project /home/vagrant/.rvm/hooks/
v "rvm rvmrc warning ignore allGemfiles"
v "gem update --system; gem update"

cp /vagrant/script/gitconfig   /home/vagrant/.gitconfig

#
# Set up the app and run the tests, which should
# all pass.
#
echo "CREATE ROLE think200_dev  WITH PASSWORD 'think200' CREATEDB LOGIN;" |  sudo -u postgres psql
echo "CREATE ROLE think200_test WITH PASSWORD 'think200' CREATEDB LOGIN;" |  sudo -u postgres psql
v "cd /vagrant; bundle install && bin/rake db:reset && RAILS_ENV=test bin/rake db:setup && bin/rspec"
