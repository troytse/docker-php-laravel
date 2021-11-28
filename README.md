# The docker environment for PHP Laravel.
This image built based-on the DockerHub official image. It included the required extensions for the Laravel. and included some common extensions.

# Table Of Contents
- [Usage](#usage)
  - [apache-buster:](#apache-buster)
  - [fpm-alpine:](#fpm-alpine)
- [Environment Variables](#environment-variables)
  - [UID and GID](#uid-and-gid)
  - [SCHEDULE](#schedule)
  - [QUEUE_WORKER](#queue_worker)
- [Console Commands](#console-commands)
- [Included Extensions](#included-extensions)

## Usage

### apache-buster:

```shell
docker run \
--restart always \
-d \
-p 80:80 \
-e UID=$(id -u) \
-e GID=$(id -g) \
-e SCHEDULE=On \
-e QUEUE_WORKER=5 \
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
-e UID=$(id -u) \
-e GID=$(id -g) \
-e SCHEDULE=On \
-e QUEUE_WORKER=5 \
-v /path/to/your/php.ini:/usr/local/etc/php/php.ini \
-v /path/to/host:/var/www/html \
troytse/php-laravel:fpm-alpine
```

## Environment Variables

### UID and GID

*(Default: 0)*

- These two variables specify to run as the user for the Apache/PHP-FPM, scheduled task, queue work, and artisan command. 
**(for apache-buster, `$UID` and `$GID` will override the `$APACHE_RUN_USER` and `$APACHE_RUN_GROUP`)**

### SCHEDULE

*(On/Off, Default: Off)*

- This variable specifies whether to add the "php artisan schedule:run" into the crontab after the container created.
- (Support to run as the user of `$UID` and `$GID`).

### QUEUE_WORKER

*(Number of works, Default: 0)*

- This variable specify how many work processes to start for "php artisan queue:work". **('0' as disabled)**
- (Support to run as the user of `$UID` and `$GID`).

- **For other environment variables, please refer to the base image**
  - [php/apache-buster](https://hub.docker.com/_/php?tab=tags&page=1&name=apache-buster)
  - [php/fpm-alpine](https://hub.docker.com/_/php?tab=tags&page=1&name=fpm-alpine)

### Console Commands

- Run artisan command in the container.
- (Support to run as the user of `$UID` and `$GID`).

```
> docker exec -it <container_name> artisan <command>
```

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
