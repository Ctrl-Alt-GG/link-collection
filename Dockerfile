FROM ghcr.io/nginx/nginx-unprivileged:1

LABEL org.opencontainers.image.description="Ctrl-Alt-GG Spawn: intranet link-collection landing page for the LAN, served as a static Hugo site by nginx."

COPY --chown=101:101 public/ /usr/share/nginx/html/

USER 101

EXPOSE 8080
