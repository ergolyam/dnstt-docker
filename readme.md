# dnstt-docker

Lightweight container image for [dnstt](https://www.bamsoftware.com/software/dnstt).

## Initial Setup

### Build

```bash
docker build -t dnstt-server .
```

### Pull

```bash
docker pull ghcr.io/ergolyam/dnstt-docker:latest
```

## Run

`DNS_ZONE` is required. Configure your DNS records so this zone is delegated to the server running the container.

- With generated key pair:
    ```bash
    docker run --rm -it \
      -p 53:53/udp \
      -e DNS_ZONE=t.example.com \
      -v ./data:/data \
      dnstt-server
    ```

- With custom UDP port:
    ```bash
    docker run --rm -it \
      -p 5353:5353/udp \
      -e PORT=5353 \
      -e DNS_ZONE=t.example.com \
      -v ./data:/data \
      dnstt-server
    ```

- With custom forward target:
    ```bash
    docker run --rm -it \
      -p 53:53/udp \
      -e DNS_ZONE=t.example.com \
      -e FORWARD=127.0.0.1:1080 \
      -v ./data:/data \
      dnstt-server
    ```

## Keys

The container generates a dnstt key pair on first start when `PRIVKEY_FILE` does not exist.

- Default generated files:
    ```plaintext
    ./data/server.key
    ./data/server.pub
    ```

Use the public key from `server.pub` when configuring dnstt clients.

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `DNS_ZONE` | - | Required DNS zone, for example `t.example.com` |
| `PORT` | `53` | UDP listen port |
| `MTU` | `1232` | Tunnel MTU |
| `FORWARD` | `127.0.0.1:1080` | Address where decoded TCP connections are forwarded |
| `PRIVKEY_FILE` | `/data/server.key` | Private key file path |
| `PUBKEY_FILE` | `/data/server.pub` | Public key file path used during key generation |
