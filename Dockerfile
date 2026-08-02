FROM ghcr.io/nginx/nginx-unprivileged:1

COPY --chown=101:101 public/ /usr/share/nginx/html/

USER 101

EXPOSE 8080
