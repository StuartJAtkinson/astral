# Use the official PHP image with version 8.2
FROM php:8.2-fpm

# Set the working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql pdo_pgsql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the application code
COPY . .

# Change ownership of the /var/www directory to www-data
RUN chown -R www-data:www-data /var/www

# Switch to the www-data user
USER www-data

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist

# Expose the port
EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]