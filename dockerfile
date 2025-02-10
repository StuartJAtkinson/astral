# Stage 1: PHP + Laravel Setup
FROM php:8.2-fpm AS laravel

# Set the working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip

# Install Composer (PHP dependency manager)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js and Yarn (for frontend setup)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn

# Copy the Laravel app files
COPY . .

# Install PHP dependencies with Composer
RUN composer install --no-interaction --optimize-autoloader

# Install Node.js dependencies for Vue (using Yarn)
RUN yarn install

# Build frontend assets using Laravel Mix
RUN yarn run dev

# Stage 2: Final Image
FROM php:8.2-fpm

# Set the working directory
WORKDIR /var/www

# Copy PHP app and built assets from the previous stage
COPY --from=laravel /var/www /var/www

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
