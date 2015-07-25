FROM ubuntu:latest
MAINTAINER Komplizierte Technologien <support@kt-team.de>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl && \
ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get -y install nginx php5-fpm php5-mysql php-apc python-setuptools mysql-client curl ssmtp pv \
php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xdebug && \
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
curl -sS https://getcomposer.org/installer | php && \
mv composer.phar /usr/local/bin/composer.phar && \
curl -o n98-magerun.phar https://raw.githubusercontent.com/netz98/n98-magerun/master/n98-magerun.phar && \
chmod +x ./n98-magerun.phar && \
mv n98-magerun.phar /usr/local/bin/n98-magerun.phar

ADD /scripts /scripts
ADD /config /config

RUN chmod 755 /scripts/*.sh && \
cp /config/nginx/nginx.conf /etc/nginx/nginx.conf && \
cp /config/nginx/nginx-host.conf /etc/nginx/sites-available/default && \
cp /config/nginx/apc.ini /etc/php5/mods-available/apcu.ini && \
cp /config/nginx/php.ini /etc/php5/fpm/php.ini && \
cp /config/nginx/php-fpm.conf /etc/php5/fpm/php-fpm.conf && \
cp /config/nginx/www.conf /etc/php5/fpm/pool.d/www.conf && \
php5enmod mcrypt && \
rm -f /etc/service/sshd/down && \
mkdir -p /tmp/sessions/ && \
chown www-data.www-data /tmp/sessions -Rf && \
sed -i -e "s:;\s*session.save_path\s*=\s*\"N;/path\":session.save_path = /tmp/sessions:g" /etc/php5/fpm/php.ini

VOLUME /var/www
EXPOSE 80

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["/bin/bash", "/scripts/start.sh"]