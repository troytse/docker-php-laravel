FROM php:fpm-alpine
# Environment
ENV UID=0
ENV GID=0
ENV SCHEDULE=off
ENV SUPERVISORD=off
# Install the necessary packages and PHP extensions
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --update busybox-suid \
    && apk add --no-cache --allow-untrusted --repository http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/community/ gnu-libiconv \
    && apk add --no-cache icu libzip freetype libjpeg-turbo libpng libmcrypt gettext openssl imap krb5 libxml2 openldap libmemcached c-client \
    && apk add --no-cache supervisor \
    # dependencies for build
    && apk add --no-cache --virtual .build-deps wget file git dpkg dpkg-dev zlib zlib-dev re2c libmagic make g++ gcc autoconf icu-dev libzip-dev freetype-dev libjpeg-turbo-dev libpng-dev libmcrypt-dev gettext-dev openssl-dev imap-dev krb5-dev libxml2-dev openldap-dev libmemcached-dev linux-headers \
    && docker-php-ext-install -j$(nproc) soap ldap intl bcmath zip exif gettext sockets pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache \
# Update pecl channel
    && pecl channel-update pecl.php.net \
# install php-msgpack
    && pecl install msgpack \
    && docker-php-ext-enable msgpack \
# install php-memcached
    && pecl install memcached \
    && docker-php-ext-enable memcached \
# Install php-redis
    && pecl install redis \
    && docker-php-ext-enable redis \
# Install swoole
    && pecl install swoole \
    && docker-php-ext-enable swoole \
# install php-igbinary
    && curl -fsSL 'https://codeload.github.com/igbinary/igbinary/tar.gz/refs/tags/3.2.14' -o igbinary.tar.gz \
    && mkdir -p igbinary \
    && tar -xf igbinary.tar.gz -C igbinary --strip-components=1 \
    && rm igbinary.tar.gz \
    && ( cd igbinary && phpize && ./configure CFLAGS="-O2 -g" --enable-igbinary && make -j$(nproc) && make install ) \
    && rm -r igbinary \
    && docker-php-ext-enable igbinary \
# Install php-mcrypt (PHP 8.1.0+ cannot be installed via PECL)
    && curl -fsSL 'https://codeload.github.com/php/pecl-encryption-mcrypt/tar.gz/refs/tags/1.0.6' -o mcrypt.tar.gz \
    && mkdir -p mcrypt \
    && tar -xf mcrypt.tar.gz -C mcrypt --strip-components=1 \
    && rm mcrypt.tar.gz \
    && ( cd mcrypt && phpize && ./configure CFLAGS="-O2 -g" --enable-mcrypt && make -j$(nproc) && make install ) \
    && rm -r mcrypt \
    && docker-php-ext-enable mcrypt \
# Initialize php.ini
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
# Clean build dependency
    && apk del --no-network .build-deps
    # no subsequent need to built, after clean up the dependencies will reduce the space.
# Install Composer
RUN curl -OL https://mirrors.aliyun.com/composer/composer.phar \
    && mv composer.phar /usr/local/bin/composer.phar \
    && chmod +x /usr/local/bin/composer.phar \
    && composer.phar config -g repo.packagist composer https://mirrors.aliyun.com/composer/
# Install suercronic
RUN curl -OL https://github.com/aptible/supercronic/releases/download/v0.2.26/supercronic-linux-amd64 \
    && mv supercronic-linux-amd64 /usr/local/bin/supercronic-linux-amd64 \
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
    && sed "2 i. /usr/local/bin/docker-php-laravel-setup" -i /usr/local/bin/docker-php-entrypoint
# Labels
LABEL Author="Troy Tse <troy@holyhi.net>"
LABEL Version="1.2.2"
LABEL Description="The Laravel runtime environment on PHP-FPM latest version."
