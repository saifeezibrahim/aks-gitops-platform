# Unprivileged nginx: runs as UID 101 and listens on 8080, so no root and no NET_BIND_SERVICE.
FROM nginxinc/nginx-unprivileged:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 8080
# Explicit non-root user (the base image already uses it; this makes it visible to scanners)
USER 101
