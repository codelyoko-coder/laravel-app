# Gunakan image PHP 8.2 dengan Apache
FROM php:8.2-apache

# Install ekstensi dan tools yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libonig-dev libxml2-dev zip curl vim \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Aktifkan mod_rewrite untuk Laravel (wajib)
RUN a2enmod rewrite

# Copy file konfigurasi Apache (untuk Laravel public folder)
COPY ./docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Tentukan folder kerja di dalam container
WORKDIR /var/www/html

# Copy semua file Laravel ke container
COPY . .

# Install dependency Laravel (tanpa dev)
RUN composer install --optimize-autoloader --no-dev

# Pastikan key Laravel ada (Render nanti butuh ini)
RUN cp .env.example .env || true
RUN php artisan key:generate || tru
