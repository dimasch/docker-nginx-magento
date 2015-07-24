#!/bin/bash
mysql -uroot -ptmp -h db -e 'create database magento;'
pv -cN source /var/www/magento/dump.sql.gz | gunzip -c | pv -cN mysql | mysql -uroot -ptmp -hdb magento