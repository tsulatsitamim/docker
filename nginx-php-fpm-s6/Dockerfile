FROM php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user=appuser
ARG uid=1000

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -o -u $uid -d /home/$user -ms /bin/bash $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

# Install wait-for-it
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /bin/wait-for-it.sh
RUN chmod +x /bin/wait-for-it.sh

# Install dependencies
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
  # mbstring [already installed]
  pcntl \
  gd \
  redis \
  zip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy custom php.ini
COPY php.ini /etc/php/7.4/fpm/conf.d/99-php.ini
COPY nginx.conf /etc/nginx/nginx.conf

COPY index.php /app/public/index.php
COPY services.d /etc/services.d/
RUN chown -R appuser:www-data /bin/wait-for-it.sh /etc/s6 /etc/services.d /etc/nginx /run /var/lib/nginx /var/log/nginx /app

# Set working directory
WORKDIR /app

USER $user

ENTRYPOINT ["/init"]
CMD []