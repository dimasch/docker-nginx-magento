#!/bin/bash

mysql -uroot -ptmp -hmysql -e "create database ${DATABASE_NAME};"
pv -cN source /var/www/magento/dump.sql.gz | gunzip -c | pv -cN mysql | mysql -uroot -ptmp -hmysql ${DATABASE_NAME}
mysql -uroot -ptmp -hmysql ${DATABASE_NAME} -e "update core_config_data set value='${BASE_URL}' where path like '%secure/base_url';"