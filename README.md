# The docker environment for PHP Laravel.
This image was built based on the DockerHub official image. It included the required extensions for Laravel. and included some common extensions.

# Table Of Contents
- [Usage](#usage)
  - [apache:](#apache)
  - [fpm-alpine:](#fpm-alpine)
- [Environment Variables](#environment-variables)
  - [UID / GID](#uid-gid)
  - [SCHEDULE](#schedule)
  - [SUPERVISORD](#supervisord)
- [Console Commands](#console-commands)
- [Included Extensions](#included-extensions)

# Usage

## apache:
This image was built based-on [php/apache](https://hub.docker.com/_/php?tab=tags&page=1&name=apache) image. Add support to Laravel's scheduled tasks, queue, and specify the execution user with `$UID` and `$GID`. The container will create the run user at startup.

The Apache service, scheduled tasks (by `artisan schedule:run`), queue work processes (by `artisan queue:work`), and any commands by artisan will run as a user with `$UID` and `$GID`.

```shell
# for docker
▶ docker run -d \
--restart always \
--hostname simple \
--name simple
-p 80:80 \
-e UID=$(id -u) \
-e GID=$(id -g) \
-e SCHEDULE=On \
-e SUPERVISORD=On \
-v /path/to/your/php.ini:/usr/local/etc/php/php.ini \
-v /path/to/host:/var/www/html \
troytse/php-laravel:apache

# for podman
▶ podman run -d \
--restart always \
--hostname simple \
--name simple
-p 80:80 \
-e UID=$(id -u) \
-e GID=$(id -g) \
--uidmap 0:0:999 --gidmap 0:0:999 \
--uidmap 1000:$(id -u):1 --gidmap 1000:$(id -g):1 \
-e SCHEDULE=On \
-e SUPERVISORD=On \
-v /path/to/your/php.ini:/usr/local/etc/php/php.ini \
-v /path/to/host:/var/www/html \
quay.io/troytse/php-laravel:apache
```

### A typical example for `apache`:

```shell
▶ docker exec -it sample ps -aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.8  0.2 223304 32828 ?        Ss   10:27   0:00 apache2 -DFOREGROUND
root        47  0.0  0.0   5512  2060 ?        Ss   10:27   0:00 /usr/sbin/cron
contain+    58  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
contain+    59  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
contain+    60  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
contain+    61  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
contain+    62  0.0  0.0 223336 10068 ?        S    10:27   0:00 apache2 -DFOREGROUND
root        65  0.0  0.1  26204 16452 ?        Ss   10:27   0:00 /usr/bin/python2 /usr/bin/supervisord -c /var/local/etc/supervisord.conf
contain+    66  1.0  0.2 107956 46652 ?        S    10:27   0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=default,high
contain+    67  0.9  0.2 107956 46636 ?        S    10:27   0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=default,high
contain+    68  1.0  0.2 107956 46968 ?        S    10:27   0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=default,high
contain+    70  0.9  0.2 107956 46636 ?        S    10:27   0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=low
contain+    71  0.9  0.2 107956 46636 ?        S    10:27   0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=low
root        99  0.0  0.0   7640  2732 pts/0    R+   10:27   0:00 ps -aux
```

## fpm-alpine:
This image was built based-on [php/fpm-alpine](https://hub.docker.com/_/php?tab=tags&page=1&name=fpm-alpine) image. Add support to Laravel's scheduled tasks, queue, and specify the execution user with `$UID` and `$GID`. The container will create the run user at startup.

The PHP-FPM processes, scheduled tasks (by `artisan schedule:run`), queue work processes (by `artisan queue:work`), and any commands by artisan will run as a user with `$UID` and `$GID`.

```shell
# for docker
▶ docker run -d \
--restart always \
--hostname sample \
--name sample \
-p 9000:9000 \
-e UID=$(id -u) \
-e GID=$(id -g) \
-e SCHEDULE=On \
-e SUPERVISORD=On \
-v /path/to/your/php.ini:/usr/local/etc/php/php.ini \
-v /path/to/host:/var/www/html \
troytse/php-laravel:fpm-alpine

# for podman
▶ podman run -d \
--restart always \
--hostname sample \
--name sample \
-p 9000:9000 \
-e UID=$(id -u) \
-e GID=$(id -g) \
--uidmap 0:0:999 --gidmap 0:0:999 \
--uidmap 1000:$(id -u):1 --gidmap 1000:$(id -g):1 \
-e SCHEDULE=On \
-e SUPERVISORD=On \
-v /path/to/your/php.ini:/usr/local/etc/php/php.ini \
-v /path/to/host:/var/www/html \
quay.io/troytse/php-laravel:fpm-alpine
```

### A typical example for `fpm-alpine`:

```shell
▶ docker exec -it sample ps -a
sample:/var/www/html# ps -A
PID   USER     TIME  COMMAND
    1 root      0:00 php-fpm: master process (/usr/local/etc/php-fpm.conf)
   25 root      0:00 /usr/local/bin/supercronic /usr/local/etc/crontab.txt
   36 containe  0:00 php-fpm: pool www
   37 containe  0:00 php-fpm: pool www
   38 root      0:00 {supervisord} /usr/bin/python3 /usr/bin/supervisord -c /usr/local/etc/supervisord.conf
   39 containe  0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=default,high
   40 containe  0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=default,high
   41 containe  0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=default,high
   42 containe  0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=low
   43 containe  0:00 /usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=low
   92 root      0:00 ps -A
```

# Environment Variables

## UID / GID
**(Default: 0)**
- These two variables specify to run as the user for the Apache/PHP-FPM, scheduled task, queue work, and artisan command.
- **(for apache, `$UID` and `$GID` will override the `$APACHE_RUN_USER` and `$APACHE_RUN_GROUP`)**

## SCHEDULE
**(On/Off, Default: Off)**
- This variable specifies whether to add the "php artisan schedule:run" into the crontab after the container is created.

## SUPERVISORD
**(On/Off, Default: Off)**
- This variable specifies whether to run the supervisor service after the container is created.

## Supervisor configuration
**(Optional)**
- Put your customized "supervisord.conf" file in the project folder.
    - Example:
    ```conf
    [program:queue-work-default]
    process_name=%(program_name)s_%(process_num)02d
    directory=/var/www/html
    command=/usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=default,high
    autostart=true
    autorestart=true
    user=%(ENV_RUN_USER)s
    numprocs=3
    redirect_stderr=true

    [program:queue-work-low]
    process_name=%(program_name)s_%(process_num)02d
    directory=/var/www/html
    command=/usr/local/bin/php /var/www/html/artisan queue:work --daemon --queue=low
    autostart=true
    autorestart=true
    user=%(ENV_RUN_USER)s
    numprocs=2
    redirect_stderr=true
    ```

## Other Environment Variables
**For other environment variables, please reference to the base image**
- [php/apache](https://hub.docker.com/_/php?tab=tags&page=1&name=apache)
- [php/fpm-alpine](https://hub.docker.com/_/php?tab=tags&page=1&name=fpm-alpine)

## Console Commands
- Run artisan command in the container.

    ```shell
    ▶ docker/podman exec -it <container_name> artisan <command>
    ```

- Run composer command in the container.

    ```shell
    ▶ docker/podman exec -it <container_name> composer <command>
    ```

- You can create a shell script in your project directory to quickly call them.

    - For example, create a shell named **"container_exec"** and content as follows:
    - docker:
    ```shell
    #!/bin/sh
    sudo docker exec -it your_container_name $@ 
    ```
    - podman:
    ```shell
    #!/bin/sh
    podman exec -it your_container_name $@ 
    ```

    - Then you can call them like this:
    ```shell
    ▶ ./container_exec artisan make:job DoSomething
    ▶ ./container_exec composer dump-autoload
    ```

    - **(The above operations will be run as the specified user by `$UID` and `$GID`.)**

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
igbinary
imap
intl
json
ldap
libxml
mbstring
memcached
msgpack
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
soap
sockets
sodium
SPL
sqlite3
standard
swoole
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
