FROM nginxinc/nginx-unprivileged:alpine

COPY default.conf /etc/nginx/conf.d/default.conf
RUN sed -i '/}/i\    application/javascript mjs;' /etc/nginx/mime.types