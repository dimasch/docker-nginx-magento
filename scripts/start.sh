#!/bin/bash

# start all the services

/usr/local/sbin/nginx &

service php5-fpm start

/usr/local/bin/supervisord -n
