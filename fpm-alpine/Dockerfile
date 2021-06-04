FROM php:fpm-alpine
ENV SET_CRONTAB=off
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --update busybox-suid \
    && apk add --no-cache icu libzip freetype libjpeg-turbo libpng libmcrypt gettext openssl \
    && apk add --no-cache --virtual .build-deps wget file git dpkg dpkg-dev zlib zlib-dev re2c libmagic make g++ gcc autoconf icu-dev libzip-dev freetype-dev libjpeg-turbo-dev libpng-dev libmcrypt-dev gettext-dev openssl-dev \
    && docker-php-ext-install -j$(nproc) bcmath zip exif gettext sockets pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install mcrypt-1.0.3 \
    && docker-php-ext-enable mcrypt \
    && pecl install redis-5.3.2 \
    && docker-php-ext-enable redis \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache \
    && apk del --no-network .build-deps \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir="/usr/local/bin" --filename="composer" \
    && php -r "unlink('composer-setup.php');" \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && echo "alias artisan='php artisan'" >> /root/.ashrc \
    && echo '#!/bin/sh\n  if [ `expr match "$SET_CRONTAB" "[O|o][N|n]$"` -ne 0 ]; then\n  \techo "* * * * * /usr/bin/sh -c \\"/usr/local/bin/php /var/www/html/artisan schedule:run >> /dev/null 2>&1\\"" > /root/crontab.txt\n  \tcrontab /root/crontab.txt\n  fi' > /root/entrypoint.sh \
    && sed "2 i/bin/sh \$HOME/entrypoint.sh" -i /usr/local/bin/docker-php-entrypoint
LABEL Author="Troy Tse <troy@holyhi.net>"
LABEL Version="1.0"
LABEL Description="The Laravel runtime environment on PHP-FPM latest version."
