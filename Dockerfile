# Used for prod build.
FROM 230208930072.dkr.ecr.us-east-1.amazonaws.com/prod-laradash-base-image:latest as php

# # Set environment variables
# ENV PHP_OPCACHE_ENABLE=1
# ENV PHP_OPCACHE_ENABLE_CLI=0
# ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
# ENV PHP_OPCACHE_REVALIDATE_FREQ=0

# # Install dependencies.
# RUN apt-get update && apt-get install -y unzip libcurl4-gnutls-dev nginx libonig-dev libonig-dev libxml2-dev

# # Install PHP extensions.
# RUN docker-php-ext-install mysqli pdo pdo_mysql bcmath curl opcache mbstring

# # Copy composer executable.
# COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

# # Install Xdebug
# RUN pecl install xdebug && docker-php-ext-enable xdebug


# # install npm
# COPY --from=node:lts-bullseye-slim /usr/local/lib/node_modules /usr/local/lib/node_modules

# # Node.jsのインストール
# COPY --from=node:lts-bullseye-slim /usr/local/bin /usr/local/bin
# COPY --from=node:lts-bullseye-slim /usr/local/lib /usr/local/lib

# Copy configuration files.
COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Set working directory to ...
WORKDIR /app

# Copy files from current folder to container current folder (set in workdir).
COPY --chown=www-data:www-data . .

# Create laravel caching folders.
RUN mkdir -p ./storage/framework
RUN mkdir -p ./storage/framework/{cache, testing, sessions, views}
RUN mkdir -p ./storage/framework/bootstrap
RUN mkdir -p ./storage/framework/bootstrap/cache

# Adjust user permission & group.
RUN usermod --uid 1000 www-data
RUN groupmod --gid 1000  www-data

# Run the entrypoint file.
ENTRYPOINT [ "docker/entrypoint.sh" ]
