FROM php:fpm-alpine
# Environment
ENV SET_CRONTAB=off
ENV USER=container
ENV UID=1000
ENV GID=1000
# Create container user
RUN addgroup -g ${GID} "${USER}" \
    && adduser --disabled-password --gecos "" --home "/var/www" --ingroup "${USER}" --no-create-home --uid "${UID}" "${USER}" \
    && chown ${UID}:${GID} /var/www
# Install the necessary packages and PHP extensions
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache --update busybox-suid \
    && apk add --no-cache icu libzip freetype libjpeg-turbo libpng libmcrypt gettext openssl \
    && apk add --no-cache --virtual .build-deps wget file git dpkg dpkg-dev zlib zlib-dev re2c libmagic make g++ gcc autoconf icu-dev libzip-dev freetype-dev libjpeg-turbo-dev libpng-dev libmcrypt-dev gettext-dev openssl-dev \
    && docker-php-ext-install -j$(nproc) bcmath zip exif gettext sockets pcntl pdo_mysql shmop sysvmsg sysvsem sysvshm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install mcrypt-1.0.4 \
    && docker-php-ext-enable mcrypt \
    && pecl install redis-5.3.4 \
    && docker-php-ext-enable redis \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache \
    && apk del --no-network .build-deps \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir="/usr/local/bin" --filename="composer" \
    && php -r "unlink('composer-setup.php');" \
    && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/ \
    && echo "alias artisan='php artisan'" >> /root/.ashrc
# for suercronic
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=048b95b48b708983effb2e5c935a1ef8483d9e3e
RUN mkdir /var/cron \
    && chown ${UID}:${GID} /var/cron \
    && curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic
COPY --chown=${UID}:${GID} cron-entrypoint.sh /var/cron/
COPY --chown=${UID}:${GID} crontabs /var/cron/
# Insert the supercronic daemon into the docker entrypoint
RUN sed "2 i/bin/sh -c \"/usr/local/bin/supercronic /var/cron/crontabs >> /dev/null 2>&1\" &" -i /usr/local/bin/docker-php-entrypoint
# Labels
LABEL Author="Troy Tse <troy@holyhi.net>"
LABEL Version="1.0.1"
LABEL Description="The Laravel runtime environment on PHP-FPM latest version."
