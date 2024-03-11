FROM rockylinux:9.3

RUN \
    dnf upgrade -y \
    && dnf install -y 'dnf-command(copr)' \
    && dnf copr enable -y @caddy/caddy \
    && dnf install -y caddy

VOLUME /var/wwww/html

EXPOSE 80/tcp 443/tcp

ENTRYPOINT [ "caddy", "run", "--config", "/etc/caddy/Caddyfile" ]