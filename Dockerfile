FROM ghcr.io/nginx/nginx-unprivileged:1.29.4-alpine@sha256:a6c4f61f456b85b8fdf7ec7ab28cc3e299440e6fb4a9dea520e5fd8fd440025e

COPY --chown=101:101 public/ /usr/share/nginx/html/

USER 101

EXPOSE 8080
