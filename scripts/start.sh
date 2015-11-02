#!/bin/bash

# start all the services

/usr/local/sbin/nginx

/etc/init.d/php5-fpm start

/usr/local/bin/supervisord -n
