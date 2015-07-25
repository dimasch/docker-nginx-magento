#!/bin/bash
mysql -uroot -ptmp -hdb -e 'create database magento;'
pv -cN source /var/www/magento/dump.sql.gz | gunzip -c | pv -cN mysql | mysql -uroot -ptmp -hdb magento
mysql -uroot -ptmp -hdb magento -e "update core_config_data set value='${BASE_URL}' where path like '%secure/base_url';"