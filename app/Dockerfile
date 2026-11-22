# Unprivileged nginx: runs as UID 101 and listens on 8080, so no root and no NET_BIND_SERVICE.
# 1.30 = current stable branch; the tag moves with patch releases.
FROM nginxinc/nginx-unprivileged:1.30-alpine

# Pick up Alpine security fixes released after the base image was built.
USER root
RUN apk upgrade --no-cache
USER 101

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 8080
