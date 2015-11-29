FROM ubuntu:latest
MAINTAINER Dmitry Schegolikhin <d.shegolihin@gmail.com>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl && \
ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get -y install php5-fpm php5-mysql php-apc python-setuptools mysql-client curl ssmtp pv nano vim mc \
php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xdebug && \
curl -o n98-magerun.phar https://raw.githubusercontent.com/netz98/n98-magerun/master/n98-magerun.phar && \
chmod +x ./n98-magerun.phar && \
mv n98-magerun.phar /usr/local/bin/n98-magerun.phar

# Install NodeJS, RequireJS, UglifyJS
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
apt-get install -y nodejs && \
npm install -g requirejs && \
npm install -g uglify-js


# Nginx with pagespeed
# Use source.list with all repositories and Yandex mirrors.
ADD sources.list /etc/apt/sources.list
RUN sed -i 's|://.*\..*\.com|://ru.archive.ubuntu.com|' /etc/apt/sources.list &&\
    echo 'force-unsafe-io' | tee /etc/dpkg/dpkg.cfg.d/02apt-speedup &&\
    echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache &&\
    echo 'Acquire::http {No-Cache=True;};' | tee /etc/apt/apt.conf.d/no-http-cache

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && apt-get clean && \
	apt-get -y install \
	ca-certificates curl  \
	wget pkg-config &&\
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && apt-get clean && \
	apt-get -y install \	
	python python-pip libgeoip-dev python-dev nginx-extras libfreetype6 libfontconfig1 \
	build-essential zlib1g-dev libpcre3 libpcre3-dev unzip libssl-dev &&\
	apt-get clean && \
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /download/directory

#Install pagecahe module
ENV NGINX_VERSION 1.9.5
ENV NPS_VERSION 1.9.32.10
RUN 	cd /usr/src &&\
	cd /usr/src &&\
	cd /usr/src && wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip &&\
	cd /usr/src && unzip release-${NPS_VERSION}-beta.zip &&\
	cd /usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta/ && pwd && wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz &&\
	cd /usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta/ && tar -xzvf ${NPS_VERSION}.tar.gz &&\
	cd /usr/src &&\
	cd /usr/src && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz &&\
	cd /usr/src && tar -xvzf nginx-${NGINX_VERSION}.tar.gz &&\
	cd /usr/src/nginx-${NGINX_VERSION}/ && ./configure --add-module=/usr/src/ngx_pagespeed-release-${NPS_VERSION}-beta \ 
         --prefix=/usr/local/share/nginx --conf-path=/etc/nginx/nginx.conf \
         --sbin-path=/usr/local/sbin --error-log-path=/var/log/nginx/error.log \
	 --with-http_ssl_module --with-ipv6 --with-http_geoip_module && \
	cd /usr/src/nginx-${NGINX_VERSION}/ && make &&\
	cd /usr/src/nginx-${NGINX_VERSION}/ && sudo make install &&\
        sed -i 's|/usr/sbin/nginx|/home/nginx|g' /etc/init.d/nginx && \
        rm /usr/sbin/nginx &&\
        mkdir -p /var/nginx/pagespeed_cache


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log



ADD /scripts /scripts
ADD /config /config

RUN chmod 755 /scripts/*.sh && \
cp /config/nginx/nginx.conf /etc/nginx/nginx.conf && \
cp /config/nginx/nginx-host.conf /etc/nginx/sites-available/default && \
cp /config/nginx/apc.ini /etc/php5/mods-available/apcu.ini && \
cp /config/nginx/php.ini /etc/php5/fpm/php.ini && \
cp /config/nginx/php-fpm.conf /etc/php5/fpm/php-fpm.conf && \
cp /config/nginx/www.conf /etc/php5/fpm/pool.d/www.conf && \
cp /config/mysql/.my.cnf /root/.my.cnf && \
php5enmod mcrypt && \
rm -f /etc/service/sshd/down && \
mkdir -p /tmp/sessions/ && \
chown www-data.www-data /tmp/sessions -Rf && \
sed -i -e "s:;\s*session.save_path\s*=\s*\"N;/path\":session.save_path = /tmp/sessions:g" /etc/php5/fpm/php.ini && \
/usr/bin/easy_install supervisor && /usr/bin/easy_install supervisor-stdout

ADD /config/supervisor/supervisord.conf /etc/supervisord.conf

VOLUME /var/www
EXPOSE 80

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["/bin/bash", "/scripts/start.sh"]
