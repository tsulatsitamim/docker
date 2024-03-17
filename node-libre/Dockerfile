ARG NODE_VERSION=20

FROM node:${NODE_VERSION}-slim

# Install libreoffice and fonts
RUN apt-get update \
    && apt-get -y --no-install-recommends install fonts-liberation2 fontconfig \
    && fc-cache \
    && apt-get -y install libreoffice-writer