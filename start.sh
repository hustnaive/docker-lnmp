#!/bin/bash

# Disable Strict Host checking for non interactive git clones
# Pull down code form git for our site!
if [ ! -z "$GIT_REPO" ]; then
  rm /var/www/site/*
  if [ ! -z "$GIT_BRANCH" ]; then
    git clone -b $GIT_BRANCH $GIT_REPO /var/www/site
  else
    git clone $GIT_REPO /var/www/site
  fi
  chown -Rf nginx.nginx /var/www/site/*
fi

# Tweak nginx to match the workers to cpu's

procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes 4/worker_processes $procs/" /etc/nginx/nginx.conf

echo 'ok'

/usr/sbin/sshd -D