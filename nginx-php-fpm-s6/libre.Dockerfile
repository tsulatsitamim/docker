FROM tsulatsitamim/nginx-php:latest

USER root

#  Enable contrib and non-free repos in Debian
RUN echo "" >> /etc/apt/sources.list
RUN echo "deb http://http.us.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org buster/updates main contrib non-free" >> /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian buster-backports main contrib non-free" >> /etc/apt/sources.list

# Install libreoffice and fonts
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
      ttf-mscorefonts-installer \
      fontconfig \
    && fc-cache \
    && apt-get -y --no-install-recommends install \
      -t buster-backports libreoffice-writer \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

USER appuser