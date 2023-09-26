# php-mcrypt is not compatible with PHP8.1 currently.
FROM php:apache-buster
ENV UID=0
ENV GID=0
ENV SCHEDULE=off
ENV QUEUE_NUM_PROCS=0
ENV QUEUE_ARGS="--daemon"
ENV QUEUE2_NUM_PROCS=0
ENV QUEUE2_ARGS="--daemon"
ENV QUEUE3_NUM_PROCS=0
ENV QUEUE3_ARGS="--daemon"
ENV ARTISAN_NUM_PROCS=0
ENV ARTISAN_ARGS=""
ENV ARTISAN2_NUM_PROCS=0
ENV ARTISAN2_ARGS=""
ENV ARTISAN3_NUM_PROCS=0
ENV ARTISAN3_ARGS=""
# Install the necessary packages and PHP extensions
RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y apt-utils wget && apt-get upgrade -y && apt-get autoremove -y \
    && apt-get install -y --no-install-recommends sudo cron supervisor libzip-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmcrypt-dev libc-client-dev libkrb5-dev libxml2-dev libldap2-dev libmemcached-dev \
    && rm -rf /var/lib/apt/lists/* \
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
# Initialize php.ini and update configurations
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && mkdir -p /var/www/html/public \
    && sed -i 's/\/var\/www\/html/\/var\/www\/html\/public/g' /etc/apache2/sites-available/000-default.conf \
    && a2enmod rewrite
# Install Composer
RUN curl -OL https://mirrors.aliyun.com/composer/composer.phar \
    && mv composer.phar /usr/local/bin/composer.phar \
    && chmod +x /usr/local/bin/composer.phar \
    && composer.phar config -g repo.packagist composer https://mirrors.aliyun.com/composer/
# Copy files
COPY supervisor.conf /usr/local/etc/
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
LABEL Version="1.2.1"
LABEL Description="The Laravel runtime environment on Apache with PHP latest version."
