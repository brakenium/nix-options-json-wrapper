# Home Assistant Add-on: Kiji Privacy Proxy

This add-on runs Dataiku Kiji Privacy Proxy inside Home Assistant so you can route
LLM requests through it and mask PII before traffic reaches upstream providers.

## Features

- Runs Kiji as a Home Assistant add-on
- Exposes forward proxy/API on port 8080
- Exposes transparent proxy mode on port 8081
- Lets you set provider keys and provider domains from add-on options
- Persists Kiji data and generated certificates in `/data`

## Install in Home Assistant

1. Copy this repository to a Git URL or local add-on repository location.
2. In Home Assistant, open Settings > Add-ons > Add-on Store.
3. Add this as a custom repository.
4. Install the add-on named Kiji Privacy Proxy.
5. Configure provider keys and options.
6. Start the add-on.

## Configure Home Assistant to use Kiji

Home Assistant does not provide one global outbound proxy switch for every
integration. The practical setup is:

1. Run this add-on and confirm it is healthy.
2. Use `http://<home-assistant-host>:8081` as HTTP and HTTPS proxy for clients
  and add-ons that support proxy environment variables.
3. For integrations that support a custom OpenAI-compatible endpoint, set the
  base URL to `http://<home-assistant-host>:8080` and keep your provider API
  key configured in this add-on.
4. If TLS errors appear in transparent mode, import and trust the CA from
  `/addon_configs/<slug>/data/certs/ca.crt` on the client making requests.

Example proxy environment variables:

- HTTP_PROXY=<http://home-assistant-host:8081>
- HTTPS_PROXY=<http://home-assistant-host:8081>
- NO_PROXY=localhost,127.0.0.1,homeassistant.local

## Configure clients to use Kiji

For any client that supports proxy environment variables, set:

- HTTP_PROXY=<http://home-assistant-host:8081>
- HTTPS_PROXY=<http://home-assistant-host:8081>

You can also use the forward proxy/API directly at:

- <http://home-assistant-host:8080>

## Notes

- This add-on is currently limited to amd64 because upstream Linux releases are
  provided as amd64 tarballs.
- Transparent mode uses a local CA certificate stored under `/data/certs`.
  Clients may need to trust this CA to avoid TLS errors.
