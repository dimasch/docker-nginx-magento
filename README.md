#docker-nginx-magento
Docker NGINX + Magento container
 
## About

This container is optimized for running Magento using NGINX and PHP-FPM

## Usage by example

### A productive development environment with Docker on OS X

```sh
https://github.com/brikis98/docker-osx-dev
```

### Install on Ubuntu

```sh
docker-compose up -d
```

### Install on OS X

```sh
docker-osx-dev
docker-compose up -d
```

### Example Yml file:

```yml
web:
 image: komplizierte/docker-nginx-magento
 ports:
  - "80:80"
 links:
  - mysql:db
 volumes:
  - .:/var/www/magento 
mysql:
 image: mysql
 env_file:
  - env    
```

#### XDebug start/stop:

```shell
./scripts/xdebug-start.sh
./scripts/xdebug-stop.sh
```

## Comments

In our example the magento container is linked to the mysql container under the alias db.
This means that you'll have to edit your config file in such a way that the mysql host is no longer localhost but db.


Regards,