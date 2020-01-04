# The docker environment for PHP Laravel.
This image built based-on the DockerHub official image. It included the required extensions for the Laravel. and included some common extensions.

## Example
```
docker run
--restart always \
-d \
-p 80:80 \
-e SET_CRONTAB=On \
-e APACHE_RUN_USER=#$(id -u) \
-e APACHE_RUN_GROUP=#$(id -g) \
-v /path/to/host:/var/www/html \
troytse/php-laravel:7.3-apache-buster
```

## Environment Variables

### SET_CRONTAB *(On/Off, Default: Off)*
- This variable specifies whether to enable automatic registration of scheduled tasks in crontab.
- Support to run as the user of `$APACHE_RUN_USER` and `$APACHE_RUN_GROUP` for the scheduled task.

### For other environment variables, please refer to the base image
* [php/apache-buster](https://hub.docker.com/_/php?tab=tags&page=1&name=apache-buster)
* [php/7.3-apache-buster](https://hub.docker.com/_/php?tab=tags&page=1&name=7.3-apache-buster)

## Included Extensions
|[PHP Modules]|||||
|---|---|---|---|---|
| bcmath | Core | ctype | curl | date |
| dom | exif | fileinfo | filter | ftp |
| gd | gettext | hash | iconv | json |
| libxml | mbstring | mcrypt | mysqlnd | openssl |
| pcntl | pcre | PDO | pdo_mysql | pdo_sqlite |
| Phar | posix | readline | redis | Reflection |
| session | shmop | SimpleXML | sockets | sodium |
| SPL | sqlite3 | standard | sysvmsg | sysvsem |
| sysvshm | tokenizer | xml | xmlreader | xmlwriter |
| Zend OPcache | zip | zlib | | |
