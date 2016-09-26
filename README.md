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

Install Docker for Mac

## Comments

In our example the magento container is linked to the mysql container under the alias db.
This means that you'll have to edit your config file in such a way that the mysql host is no longer localhost but db.


Regards,
