FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user=appuser
ARG uid=1000

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Download script to install PHP extensions and dependencies
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync

# Install PHP extensions
RUN install-php-extensions \
  bcmath \
  exif \
  intl \
  opcache \
  pdo_mysql \
  mbstring \
  pcntl \
  gd \
  redis

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Add wait-for-it
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /bin/wait-for-it.sh
RUN chmod +x /bin/wait-for-it.sh

# Add S6 supervisor (for graceful stop)
COPY s6.gz /tmp/s6-overlay-amd64.tar.gz
# ADD https://github.com/just-containers/s6-overlay/releases/download/v2.0.0.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude='./bin' && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin

# Copy custom php.ini
COPY php.ini /etc/php/7.4/fpm/conf.d/99-php.ini
COPY nginx.conf /etc/nginx/nginx.conf

# COPY index.php /app/public/index.php
COPY services.d /etc/services.d/
RUN mkdir /app
RUN chown -R appuser:www-data /bin/wait-for-it.sh /etc/s6 /etc/services.d /etc/nginx /run /var/lib/nginx /var/log/nginx /app

# Set working directory
WORKDIR /app

USER $user

ENTRYPOINT ["/init"]
CMD []