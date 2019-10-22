FROM php:7.3-apache-buster
RUN sed -i 's/deb.debian.org/mirrors.huaweicloud.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.huaweicloud.com/g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y apt-utils && apt-get upgrade -y && apt-get autoremove -y \
    && apt-get install -y --no-install-recommends libzip-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmcrypt-dev \
	&& rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) bcmath zip exif gettext sockets pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable mcrypt \
    && pecl install redis-5.0.0 \
    && docker-php-ext-enable redis \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache \
	&& mkdir -p /var/www/html/public \
	&& sed -i 's/\/var\/www\/html/\/var\/www\/html\/public/g' /etc/apache2/sites-available/000-default.conf \
	&& a2enmod rewrite
