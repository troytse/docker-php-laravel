# The docker environment for PHP Laravel.
This image was built based on the DockerHub official image. It included the required extensions for Laravel. and included some common extensions.

# Table Of Contents
- [Usage](#usage)
  - [apache-buster:](#apache-buster)
  - [fpm-alpine:](#fpm-alpine)
- [Environment Variables](#environment-variables)
  - [UID / GID](#uid-gid)
  - [SCHEDULE](#schedule)
  - [QUEUE_NUM_PROCS](#queue_num_procs)
  - [QUEUE_ARGS](#queue_args)
- [Console Commands](#console-commands)
- [Included Extensions](#included-extensions)

# Usage

## apache-buster:
This image was built based-on [php/apache-buster](https://hub.docker.com/_/php?tab=tags&page=1&name=apache-buster) image. Add support to Laravel's scheduled tasks, queue, and specify the execution user with `$UID` and `$GID`. The container will create the run user at startup.

The Apache service, scheduled tasks (by `artisan schedule:run`), queue work processes (by `artisan queue:work`), and any commands by artisan will run as a user with `$UID` and `$GID`.

```shell
▶ docker run \
--restart always \
--hostname simple \
--name simple
-d \
-p 80:80 \
-e UID=$(id -u) \
-e GID=$(id -g) \
-e SCHEDULE=On \
-e QUEUE_NUM_PROCS=3 \
-e QUEUE_ARGS="--daemon" \
-v /path/to/your/php.ini:/usr/local/etc/php/php.ini \
-v /path/to/host:/var/www/html \
troytse/php-laravel:apache-buster
```

### A typical example for `apache-buster`:

```shell
▶ docker exec -it sample bash
root@sample:/var/www/html# ps -aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.8  0.2 223304 32828 ?        Ss   10:27   0:00 apache2 -DFOREGROUND
root        47  0.0  0.0   5512  2060 ?        Ss   10:27   0:00 /usr/sbin/cron
contain+    58  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
contain+    59  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
contain+    60  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
contain+    61  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
contain+    62  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
root        65  0.0  0.1  26204 16452 ?        Ss   10:27   0:00 /usr/bin/python2 /usr/bin/supervisord -c /var/supervisor/supervisor.conf
contain+    66  1.0  0.2 107956 46652 ?        S    10:27   0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon
contain+    67  0.9  0.2 107956 46636 ?        S    10:27   0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon
contain+    68  1.0  0.2 107956 46968 ?        S    10:27   0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon
root        93  0.3  0.0   3868  3220 pts/0    Ss   10:27   0:00 bash
root        99  0.0  0.0   7640  2732 pts/0    R+   10:27   0:00 ps -aux
```

## fpm-alpine:
This image was built based-on [php/fpm-alpine](https://hub.docker.com/_/php?tab=tags&page=1&name=fpm-alpine) image. Add support to Laravel's scheduled tasks, queue, and specify the execution user with `$UID` and `$GID`. The container will create the run user at startup.

The PHP-FPM processes, scheduled tasks (by `artisan schedule:run`), queue work processes (by `artisan queue:work`), and any commands by artisan will run as a user with `$UID` and `$GID`.

```shell
▶ docker run \
--restart always \
--hostname sample \
--name sample
-d \
-p 9000:9000 \
-e UID=$(id -u) \
-e GID=$(id -g) \
-e SCHEDULE=On \
-e QUEUE_NUM_PROC=3 \
-e QUEUE_ARGS="--daemon" \
-v /path/to/your/php.ini:/usr/local/etc/php/php.ini \
-v /path/to/host:/var/www/html \
troytse/php-laravel:fpm-alpine
```

### A typical example for `fpm-alpine`:

```shell
▶ docker exec -it sample ash
sample:/var/www/html# ps -A
PID   USER     TIME  COMMAND
    1 root      0:00 php-fpm: master process (/usr/local/etc/php-fpm.conf)
   25 root      0:00 /usr/local/bin/supercronic /var/cron/crontabs
   36 containe  0:00 php-fpm: pool www
   37 containe  0:00 php-fpm: pool www
   38 root      0:00 {supervisord} /usr/bin/python3 /usr/bin/supervisord -c /var/supervisor/supervisor.conf
   39 containe  0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon
   40 containe  0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon
   41 containe  0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon
   83 root      0:00 ash
   92 root      0:00 ps -A
```

# Environment Variables

## UID / GID
**(Default: 0)**
- These two variables specify to run as the user for the Apache/PHP-FPM, scheduled task, queue work, and artisan command.
- **(for apache-buster, `$UID` and `$GID` will override the `$APACHE_RUN_USER` and `$APACHE_RUN_GROUP`)**

## SCHEDULE
**(On/Off, Default: Off)**
- This variable specifies whether to add the "php artisan schedule:run" into the crontab after the container created.

## QUEUE_NUM_PROCS
**(Number of work processes, Default: 0, 0 as disabled)**
- This variable specify how many work processes to start for "artisan queue:work".

## QUEUE_ARGS
**(String, Default: "--daemon")**
- This variable specifies the worker arguments for "artisan queue:work $QUEUE_ARGS".

## Other Environment Variables
**For other environment variables, please reference to the base image**
- [php/apache-buster](https://hub.docker.com/_/php?tab=tags&page=1&name=apache-buster)
- [php/fpm-alpine](https://hub.docker.com/_/php?tab=tags&page=1&name=fpm-alpine)

## Console Commands
- Run artisan command in the container.

```shell
▶ docker exec -it <container_name> artisan <command>
```

# Included Extensions

```shell
[PHP Modules]
bcmath
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
json
libxml
mbstring
mcrypt
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
shmop
SimpleXML
sockets
sodium
SPL
sqlite3
standard
sysvmsg
sysvsem
sysvshm
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```
