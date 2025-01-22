FROM php:apache
ENV UID=0
ENV GID=0
ENV SCHEDULE=off
ENV SUPERVISORD=off
# Install the necessary packages and PHP extensions
ARG BUILD_DEPS="libbrotli-dev libzip-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmcrypt-dev libc-client-dev libkrb5-dev libxml2-dev libldap2-dev libmemcached-dev"
RUN sed -i 's|deb.debian.org|mirrors.ustc.edu.cn|g' /etc/apt/sources.list.d/debian.sources \
    && sed -i 's|security.debian.org|mirrors.ustc.edu.cn|g' /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y apt-utils wget && apt-get upgrade -y && apt-get autoremove -y \
    && apt-get install -y --no-install-recommends sudo cron supervisor $BUILD_DEPS \
    && rm -rf /var/lib/apt/lists/* \
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
# Install swoole
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
# Clean build dependency
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove $BUILD_DEPS \
# Initialize php.ini and update configurations
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && mkdir -p /var/www/html/public \
    && sed -i 's/\/var\/www\/html/\/var\/www\/html\/public/g' /etc/apache2/sites-available/000-default.conf \
    && a2enmod rewrite \
# Install Composer
    && curl -L -o /usr/local/bin/composer.phar https://mirrors.aliyun.com/composer/composer.phar \
    && chmod +x /usr/local/bin/composer.phar \
    && composer.phar config -g repo.packagist composer https://mirrors.aliyun.com/composer/
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
LABEL Description="The Laravel runtime environment on Apache with PHP latest version."
