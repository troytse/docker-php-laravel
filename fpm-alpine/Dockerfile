FROM php:fpm-alpine
# Environment
ENV UID=0
ENV GID=0
ENV SCHEDULE=off
ENV SUPERVISORD=off
# Install the necessary packages and PHP extensions
RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.ustc.edu.cn|g' /etc/apk/repositories \
# RUN apk update \
    && apk add --no-cache --update busybox-suid \
    # && apk add --no-cache --allow-untrusted --repository https://mirrors.ustc.edu.cn/alpine/edge/community/ gnu-libiconv \
    && apk add --no-cache --allow-untrusted gnu-libiconv \
    && apk add --no-cache icu libzip freetype libjpeg-turbo libpng libmcrypt gettext openssl imap krb5 libxml2 openldap libmemcached c-client \
    && apk add --no-cache supervisor \
    # dependencies for build
    && apk add --no-cache --virtual .build-deps wget file git dpkg dpkg-dev zlib zlib-dev re2c libmagic make g++ gcc autoconf icu-dev libzip-dev brotli-dev freetype-dev libjpeg-turbo-dev libpng-dev libmcrypt-dev gettext-dev openssl-dev imap-dev krb5-dev libxml2-dev openldap-dev libmemcached-dev linux-headers \
    && docker-php-ext-install -j$(nproc) soap ldap intl bcmath zip exif gettext sockets pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache \
# Update pecl channel
    && pecl channel-update pecl.php.net \
# install php-imap
    && pecl install imap \
    && docker-php-ext-enable imap \
# install php-msgpack
    && pecl install msgpack \
    && docker-php-ext-enable msgpack \
# install php-memcached
    && pecl install memcached \
    && docker-php-ext-enable memcached \
# Install php-redis
    && pecl install redis \
    && docker-php-ext-enable redis \
# Install php-swoole
    && pecl install swoole \
    && docker-php-ext-enable swoole \
# install php-igbinary
    && curl -fsSL -o igbinary.tar.gz https://ghfast.top/https://github.com/igbinary/igbinary/archive/refs/tags/3.2.16.tar.gz \
    && mkdir -p igbinary \
    && tar -xf igbinary.tar.gz -C igbinary --strip-components=1 \
    && rm -f igbinary.tar.gz \
    && ( cd igbinary && phpize && ./configure CFLAGS="-O2 -g" --enable-igbinary && make -j$(nproc) && make install ) \
    && rm -rf igbinary \
    && docker-php-ext-enable igbinary \
# Initialize php.ini
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
# Clean build dependency
    && apk del --no-network .build-deps \
    # no subsequent need to built, after clean up the dependencies will reduce the space.
# Install Composer
    && curl -L -o /usr/local/bin/composer.phar https://mirrors.aliyun.com/composer/composer.phar \
    && chmod +x /usr/local/bin/composer.phar \
    && composer.phar config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
# Install suercronic
    && curl -L -o /usr/local/bin/supercronic-linux-amd64 https://ghfast.top/https://github.com/aptible/supercronic/releases/download/v0.2.33/supercronic-linux-amd64 \
    && chmod +x /usr/local/bin/supercronic-linux-amd64 \
    && ln -s /usr/local/bin/supercronic-linux-amd64 /usr/local/bin/supercronic
# Copy files
COPY supervisord.conf /usr/local/etc/
COPY crontab.txt /usr/local/etc/
COPY composer /usr/local/bin/
COPY artisan /usr/local/bin/
COPY docker-cron-entrypoint /usr/local/bin/
COPY docker-php-laravel-setup /usr/local/bin/
# Update permissions
RUN chmod +x /usr/local/bin/composer \
    && chmod +x /usr/local/bin/artisan \
    && chmod +x /usr/local/bin/docker-cron-entrypoint \
    && chmod +x /usr/local/bin/docker-php-laravel-setup \
# Insert the setup command into the docker entrypoint
    && sed -i "2i. /usr/local/bin/docker-php-laravel-setup" /usr/local/bin/docker-php-entrypoint
# Labels
LABEL Author="Troy Tse <troy@holyhi.net>"
LABEL Version="1.2.3"
LABEL Description="The Laravel runtime environment on PHP-FPM latest version."
