FROM php:apache

MAINTAINER Damien HARPER <damien.harper@gmail.com>

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpcre3-dev \
	# Install Composer \
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
	&& composer --version \
	# Install Symfony installer \
	&& curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony \
	&& chmod a+x /usr/local/bin/symfony \
	&& symfony --version \
	# Set timezone \
	&& rm /etc/localtime \
	&& ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime \
	&& "date" \
	# Create error_log \
	&& mkdir /var/log/php \
	&& touch /var/log/php/php_error.log \
	# Type docker-php-ext-install to see available extensions \
	&& docker-php-ext-install pdo pdo_mysql \
	# enable opcache \
	&& docker-php-ext-enable opcache \
	# install apcu \
	&& pecl install apcu \
	&& docker-php-ext-enable apcu \
	# install xdebug \
	&& pecl install xdebug \
	&& docker-php-ext-enable xdebug \
	# aliases \
	&& echo 'alias sf="php bin/console"' >> ~/.bashrc

WORKDIR /var/www/symfony
