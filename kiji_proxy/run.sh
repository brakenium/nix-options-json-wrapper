#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -euo pipefail

bashio::log.info "Configuring Kiji Privacy Proxy add-on"

mkdir -p /data/certs

PROXY_PORT="$(bashio::config 'proxy_port')"
TRANSPARENT_PROXY_PORT="$(bashio::config 'transparent_proxy_port')"

export KIJI_DATA_PATH="/data"
export PROXY_PORT=":${PROXY_PORT}"
TRANSPARENT_PROXY_ENABLED="$(bashio::config 'transparent_proxy_enabled')"
export TRANSPARENT_PROXY_ENABLED
export TRANSPARENT_PROXY_PORT=":${TRANSPARENT_PROXY_PORT}"
export TRANSPARENT_PROXY_CA_PATH="/data/certs/ca.crt"
export TRANSPARENT_PROXY_KEY_PATH="/data/certs/ca.key"

DETECTOR_NAME="$(bashio::config 'detector_name')"
LOG_PII_CHANGES="$(bashio::config 'log_pii_changes')"
LOG_REQUESTS="$(bashio::config 'log_requests')"
LOG_RESPONSES="$(bashio::config 'log_responses')"
LOG_VERBOSE="$(bashio::config 'log_verbose')"
export DETECTOR_NAME LOG_PII_CHANGES LOG_REQUESTS LOG_RESPONSES LOG_VERBOSE

OPENAI_BASE_URL="$(bashio::config 'openai_base_url')"
ANTHROPIC_BASE_URL="$(bashio::config 'anthropic_base_url')"
GEMINI_BASE_URL="$(bashio::config 'gemini_base_url')"
MISTRAL_BASE_URL="$(bashio::config 'mistral_base_url')"
export OPENAI_BASE_URL ANTHROPIC_BASE_URL GEMINI_BASE_URL MISTRAL_BASE_URL

OPENAI_API_KEY="$(bashio::config 'openai_api_key')"
ANTHROPIC_API_KEY="$(bashio::config 'anthropic_api_key')"
GEMINI_API_KEY="$(bashio::config 'gemini_api_key')"
MISTRAL_API_KEY="$(bashio::config 'mistral_api_key')"

if [[ -n "${OPENAI_API_KEY}" ]]; then
    export OPENAI_API_KEY
fi
if [[ -n "${ANTHROPIC_API_KEY}" ]]; then
    export ANTHROPIC_API_KEY
fi
if [[ -n "${GEMINI_API_KEY}" ]]; then
    export GEMINI_API_KEY
fi
if [[ -n "${MISTRAL_API_KEY}" ]]; then
    export MISTRAL_API_KEY
fi

# The Linux release serves UI by default at the API port unless disabled.
if [[ "$(bashio::config 'serve_ui')" == "true" ]]; then
    unset KIJI_SERVE_UI
else
    export KIJI_SERVE_UI="false"
fi

bashio::log.info "Starting Kiji Privacy Proxy"
exec /opt/kiji-proxy/bin/kiji-proxy
