FROM php:fpm-alpine
# Environment
ENV UID=0
ENV GID=0
ENV SCHEDULE=off
ENV QUEUE_NUM_PROCS=0
ENV QUEUE_ARGS="--daemon"
ENV ENV=/etc/profile
RUN cp /etc/resolv.conf /etc/resolv.conf.original \
    && echo "nameserver 223.5.5.5" > /etc/resolv.conf \
    && echo "nameserver 223.6.6.6" >> /etc/resolv.conf \
# Install the necessary packages and PHP extensions
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --update busybox-suid \
    && apk add --no-cache icu libzip freetype libjpeg-turbo libpng libmcrypt gettext openssl \
    && apk add --no-cache supervisor \
    # dependencies for build
    && apk add --no-cache --virtual .build-deps wget file git dpkg dpkg-dev zlib zlib-dev re2c libmagic make g++ gcc autoconf icu-dev libzip-dev freetype-dev libjpeg-turbo-dev libpng-dev libmcrypt-dev gettext-dev openssl-dev \
    && docker-php-ext-install -j$(nproc) bcmath zip exif gettext sockets pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache \
# Update SSL certs
    && wget -P /etc/ssl/certs/ http://curl.haxx.se/ca/cacert.pem \
    && chmod 744 /etc/ssl/certs/cacert.pem \
    && pecl channel-update pecl.php.net \
# Install php-mcrypt
    && pecl install mcrypt \
    && docker-php-ext-enable mcrypt \
# Install php-redis
    && pecl install redis \
    && docker-php-ext-enable redis \
# Initialize php.ini
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
# Clean build dependency
    && apk del --no-network .build-deps
    # no subsequent need to built, after clean up the dependencies will reduce the space.
# Install Composer
RUN curl -OL https://mirrors.aliyun.com/composer/composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
# Install suercronic
RUN curl -OL https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    && mv supercronic-linux-amd64 /usr/local/bin/supercronic-linux-amd64 \
    && chmod +x /usr/local/bin/supercronic-linux-amd64 \
    && ln -s /usr/local/bin/supercronic-linux-amd64 /usr/local/bin/supercronic
# Copy files
COPY supervisor.conf /usr/local/etc/
COPY crontab.txt /usr/local/etc/
COPY artisan /usr/local/bin/
COPY docker-cron-entrypoint /usr/local/bin/
COPY docker-php-laravel-setup /usr/local/bin/
# Update permissions
RUN chmod +x /usr/local/bin/artisan \
    && chmod +x /usr/local/bin/docker-cron-entrypoint \
    && chmod +x /usr/local/bin/docker-php-laravel-setup \
# Insert the setup command into the docker entrypoint
    && sed "2 i. /usr/local/bin/docker-php-laravel-setup" -i /usr/local/bin/docker-php-entrypoint
# Labels
LABEL Author="Troy Tse <troy@holyhi.net>"
LABEL Version="1.1.0"
LABEL Description="The Laravel runtime environment on PHP-FPM latest version."
