#!/bin/sh

set -e

: "${PORT:=53}"
: "${MTU:=1232}"
: "${FORWARD:=127.0.0.1:1080}"
: "${PRIVKEY_FILE:=/data/server.key}"
: "${PUBKEY_FILE:=/data/server.pub}"

if [ -z "${DNS_ZONE:-}" ]; then
    echo "ERROR: DNS_ZONE is not set." >&2
    echo "Please set your own DNS_ZONE, for example:" >&2
    echo "  DNS_ZONE=t.example.com" >&2
    exit 1
fi

mkdir -p "$(dirname "$PRIVKEY_FILE")"

if [ ! -s "$PRIVKEY_FILE" ]; then
    echo "dnstt private key not found, generating key pair..."
    /app/dnstt-server -gen-key -privkey-file "$PRIVKEY_FILE" -pubkey-file "$PUBKEY_FILE"
fi

exec /app/dnstt-server -udp ":$PORT" -privkey-file "$PRIVKEY_FILE" -mtu "$MTU" "$DNS_ZONE" "$FORWARD"
