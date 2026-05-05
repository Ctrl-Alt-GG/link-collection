# Dev container image for Ctrl-Alt-GG Spawn.
#
# Versions are NOT hard-coded here — they are read from the repository's
# canonical sources at build time:
#   * Node.js: `.nvmrc`
#   * Hugo (extended): `module.hugoVersion.min` in `config.toml`
#
# Bumping `.nvmrc` or `config.toml` is enough; rebuild the dev container
# and the new versions are picked up automatically.

FROM mcr.microsoft.com/devcontainers/base:bookworm

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Pull in the pinned-version files. Build context is the repo root
# (see `build.context` in devcontainer.json).
COPY .nvmrc /tmp/spawn/.nvmrc
COPY config.toml /tmp/spawn/config.toml

# Install Node.js at the major version pinned in .nvmrc via NodeSource.
RUN set -euo pipefail; \
    NODE_MAJOR="$(sed -E 's/^v//; s/[[:space:]]//g' /tmp/spawn/.nvmrc | cut -d. -f1)"; \
    if [ -z "${NODE_MAJOR}" ]; then echo "Could not read Node major version from .nvmrc" >&2; exit 1; fi; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg; \
    mkdir -p /etc/apt/keyrings; \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg; \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" \
        > /etc/apt/sources.list.d/nodesource.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends nodejs; \
    rm -rf /var/lib/apt/lists/*; \
    node --version; \
    npm --version

# Install Hugo extended at the version pinned in config.toml.
RUN set -euo pipefail; \
    HUGO_VERSION="$(sed -n '/^[[:space:]]*\[module\.hugoVersion\]/,/^[[:space:]]*\[/{s/^[[:space:]]*min[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/p}' /tmp/spawn/config.toml | head -n 1)"; \
    if [ -z "${HUGO_VERSION}" ]; then echo "Could not read Hugo version from config.toml" >&2; exit 1; fi; \
    case "$(dpkg --print-architecture)" in \
        amd64) HUGO_ARCH="linux-amd64" ;; \
        arm64) HUGO_ARCH="linux-arm64" ;; \
        *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.tar.gz" \
        -o /tmp/hugo.tar.gz; \
    tar -xzf /tmp/hugo.tar.gz -C /usr/local/bin hugo; \
    rm /tmp/hugo.tar.gz; \
    hugo version

# Clean up the staged copies — the workspace mount provides the live files.
RUN rm -rf /tmp/spawn
