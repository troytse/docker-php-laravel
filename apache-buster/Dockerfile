FROM php:apache-buster
ENV SET_CRONTAB=off
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y apt-utils wget && apt-get upgrade -y && apt-get autoremove -y \
    && apt-get install -y --no-install-recommends sudo cron libzip-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmcrypt-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) bcmath zip exif gettext sockets pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install mcrypt-1.0.3 \
    && docker-php-ext-enable mcrypt \
    && pecl install redis-5.2.2 \
    && docker-php-ext-enable redis \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache \
    && mkdir -p /var/www/html/public \
    && sed -i 's/\/var\/www\/html/\/var\/www\/html\/public/g' /etc/apache2/sites-available/000-default.conf \
    && a2enmod rewrite \
    && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir="/usr/local/bin" --filename="composer" \
    && php -r "unlink('composer-setup.php');" \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && echo "alias artisan='sudo -H -u \$APACHE_RUN_USER -g \$APACHE_RUN_GROUP php artisan'" >> /root/.bashrc \
    && echo '#!/bin/sh\nif [ `expr match "$SET_CRONTAB" "[O|o][N|n]$"` -ne 0 ]; then\n\techo "* * * * * /usr/bin/sudo -H -u \\"$APACHE_RUN_USER\\" -g \\"$APACHE_RUN_GROUP\\" bash -c \\"/usr/local/bin/php /var/www/html/artisan schedule:run >> /dev/null 2>&1\\"" > /root/crontab.txt\n\tcrontab /root/crontab.txt\n\t/etc/init.d/cron start\nfi' > /root/entrypoint.sh \
    && sed "2 i/bin/sh /root/entrypoint.sh" -i /usr/local/bin/docker-php-entrypoint
LABEL Author="Troy Tse <troy@holyhi.net>"
LABEL Version="1.0"
LABEL Description="The Laravel runtime environment on Apache with PHP latest version."
