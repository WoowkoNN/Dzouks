FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u 1000 -d /home/sammy sammy
RUN mkdir -p /home/sammy/.composer && \
    chown -R sammy:sammy /home/sammy

#RUN pecl install xdebug \
#    && docker-php-ext-enable xdebug

#COPY ./xdebug.ini "${PHP_INI_DIR}/conf.d"



# Set working directory
WORKDIR /var/www

USER sammy