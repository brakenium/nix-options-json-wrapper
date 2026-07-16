ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.22
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    jq \
    tar

ARG KIJI_VERSION=1.6.3

RUN set -euo pipefail; \
    REPO="dataiku/kiji-proxy"; \
    TAG="v${KIJI_VERSION}"; \
    ARCHIVE="kiji-privacy-proxy-${KIJI_VERSION}-linux-amd64.tar.gz"; \
    URL="https://github.com/${REPO}/releases/download/${TAG}/${ARCHIVE}"; \
    curl -fsSL -o "/tmp/${ARCHIVE}" "${URL}"; \
    curl -fsSL -o "/tmp/${ARCHIVE}.sha256" "${URL}.sha256"; \
    cd /tmp; \
    sha256sum -c "${ARCHIVE}.sha256"; \
    mkdir -p /opt/kiji-proxy; \
    tar -xzf "/tmp/${ARCHIVE}" -C /opt/kiji-proxy --strip-components=1; \
    rm -f "/tmp/${ARCHIVE}" "/tmp/${ARCHIVE}.sha256"; \
    chmod +x /opt/kiji-proxy/bin/kiji-proxy /opt/kiji-proxy/run.sh

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
