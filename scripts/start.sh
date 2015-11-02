#!/bin/bash

# start all the services

/usr/local/sbin/nginx

/usr/local/bin/supervisord -n
