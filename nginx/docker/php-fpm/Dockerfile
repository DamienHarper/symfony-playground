FROM php:fpm

MAINTAINER Damien HARPER <damien.harper@gmail.com>

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpcre3-dev

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Install Symfony installer
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony
RUN symfony --version

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
RUN "date"

# Create error_log
RUN mkdir /var/log/php
RUN touch /var/log/php/php_error.log

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql

# enable opcache
RUN docker-php-ext-enable opcache

# install apcu
RUN pecl install apcu
RUN docker-php-ext-enable apcu

# install xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# aliases
RUN echo 'alias sf="php bin/console"' >> ~/.bashrc

WORKDIR /var/www/symfony
