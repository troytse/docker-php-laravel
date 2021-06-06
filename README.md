# The docker environment for PHP Laravel.
This image built based-on the DockerHub official image. It included the required extensions for the Laravel. and included some common extensions.

# Table Of Contents
- [Usage](#usage)
  - [apache-buster:](#apache-buster)
  - [fpm-alpine:](#fpm-alpine)
- [Environment Variables](#environment-variables)
  - [SET_CRONTAB](#set_crontab)
- [Included Extensions](#included-extensions)

## Usage

### apache-buster:

```shell
docker run \
--restart always \
-d \
-p 80:80 \
-e SET_CRONTAB=On \
-e APACHE_RUN_USER=#$(id -u) \
-e APACHE_RUN_GROUP=#$(id -g) \
-v /path/to/your/php.ini:/usr/local/etc/php/php.ini \
-v /path/to/host:/var/www/html \
troytse/php-laravel:apache-buster
```

### fpm-alpine:

```shell
docker run \
--restart always \
-d \
-p 9000:9000 \
-u $(id -u):$(id -g) \
-e UID=$(id -u) \
-e GID=$(id -g) \
-e SET_CRONTAB=On \
-v /path/to/your/php.ini:/usr/local/etc/php/php.ini \
-v /path/to/host:/var/www/html \
troytse/php-laravel:fpm-alpine
```

## Environment Variables

### SET_CRONTAB

*(On/Off, Default: Off)*

- This variable specifies whether to add the "php artisan schedule::run" into the crontab after the container created.

- Support to run as the user of `$APACHE_RUN_USER` and `$APACHE_RUN_GROUP` for the scheduled task. **(apache only)**

- **For other environment variables, please refer to the base image**
  - [php/apache-buster](https://hub.docker.com/_/php?tab=tags&page=1&name=apache-buster)
  - [php/fpm-alpine](https://hub.docker.com/_/php?tab=tags&page=1&name=fpm-alpine)

## Included Extensions

|[PHP Modules]|||||
|---|---|---|---|---|
| bcmath | Core | ctype | curl | date |
| dom | exif | fileinfo | filter | ftp |
| **gd** | gettext | hash | iconv | json |
| libxml | mbstring | **mcrypt** | mysqlnd | openssl |
| pcntl | pcre | PDO | pdo_mysql | pdo_sqlite |
| Phar | posix | readline | **redis** | Reflection |
| session | shmop | SimpleXML | sockets | sodium |
| SPL | sqlite3 | standard | sysvmsg | sysvsem |
| sysvshm | tokenizer | xml | xmlreader | xmlwriter |
| Zend OPcache | zip | zlib | | |
