# php-mcrypt is not compatible with PHP8.1 currently.
FROM php:8.0-apache-buster
ENV UID=0
ENV GID=0
ENV SCHEDULE=off
ENV QUEUE_NUM_PROCS=0
ENV QUEUE_ARGS="--daemon"
RUN cp /etc/resolv.conf /etc/resolv.conf.original \
    && echo "nameserver 223.5.5.5" > /etc/resolv.conf \
    && echo "nameserver 223.6.6.6" >> /etc/resolv.conf \
# Install the necessary packages and PHP extensions
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y apt-utils wget && apt-get upgrade -y && apt-get autoremove -y \
    && apt-get install -y --no-install-recommends sudo cron supervisor libzip-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmcrypt-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) bcmath zip exif gettext sockets pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache \
# Install php-mcrypt
    && pecl install mcrypt \
    && docker-php-ext-enable mcrypt \
# Install php-redis
    && pecl install redis \
    && docker-php-ext-enable redis \
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
LABEL Version="1.1.1"
LABEL Description="The Laravel runtime environment on Apache with PHP latest version."
