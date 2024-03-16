FROM chialab/php:7.4-fpm

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

ARG UID=1000
RUN useradd -G www-data,root -o -u ${UID} -ms /bin/bash appuser

# Add wait-for-it
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /bin/wait-for-it.sh
RUN chmod +x /bin/wait-for-it.sh

# # Add S6 supervisor (for graceful stop)
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install nginx \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy custom php.ini
COPY php.ini /etc/php/7.4/fpm/conf.d/99-php.ini
COPY nginx.conf /etc/nginx/nginx.conf

COPY index.php /app/public/index.php
COPY services.d /etc/services.d/
RUN chown -R appuser:www-data /bin/wait-for-it.sh /etc/s6 /etc/services.d /etc/nginx /run /var/lib/nginx /var/log/nginx /app

WORKDIR /app
USER appuser

ENTRYPOINT ["/init"]
CMD []