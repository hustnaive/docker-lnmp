#!/bin/bash
# Tweak nginx to match the workers to cpu's

procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes 4/worker_processes $procs/" /etc/nginx/nginx.conf
sed -i -e "s/^listen.*$/listen = 9000/" /etc/php5/fpm/pool.d/www.conf

/etc/init.d/nginx start
/etc/init.d/php5-fpm start
/etc/init.d/memcached start


/usr/sbin/sshd -D