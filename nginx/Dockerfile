FROM nginxinc/nginx-unprivileged:alpine

RUN curl -L -o /etc/nginx/conf.d/default.conf https://bit.ly/nginx-spa
RUN sed -i '/}/i\    application/javascript mjs;' /etc/nginx/mime.types