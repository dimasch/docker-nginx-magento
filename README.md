#docker-nginx-magento
Docker NGINX + Magento container

## About

This container is optimized for running Magento using NGINX and PHP-FPM

## Usage by example

### Install on Ubuntu

```sh
docker-compose up -d
```

### Install on OS X

```sh
docker-osx-dev
docker-compose up -d
```
For more information about productive development environment with Docker on OS X:
https://github.com/brikis98/docker-osx-dev

### Import database

Put "dump.sql.gz" to project root folder and execute script:

```sh
docker exec -it kmplzt_web_1 /scripts/import.sh
```

Where kmplzt_web_1 the project cotainer name, for show list of containers in current directory use:

```sh
docker-compose ps
```


### My /etc/hosts on my Mac looks like:

```sh
127.0.0.1    localhost
192.168.59.103	  dockerhost
192.168.59.103	  kmplzt.dev
```

### On a Linux box, it will look like this:

```sh
127.0.0.1    localhost kmplzt.dev
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