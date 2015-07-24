#!/bin/bash
mysql -uroot -p123 -h db -e 'create database magento;'
pv -cN source /var/www/magento/dump.sql.gz | gunzip -c | pv -cN mysql | mysql -uroot -p123 -hdb magento