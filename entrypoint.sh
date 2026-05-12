#!/bin/sh

set -e

: "${PORT:=53}"
: "${MTU:=1232}"
: "${DNS_ZONE:=t.example.com}"
: "${FORWARD:=127.0.0.1:1080}"
: "${PRIVKEY_FILE:=/data/server.key}"
: "${PUBKEY_FILE:=/data/server.pub}"

mkdir -p $(dirname $PRIVKEY_FILE)

if [ ! -s "$PRIVKEY_FILE" ]; then
    echo "dnstt private key not found, generating key pair..."
    /app/dnstt-server -gen-key -privkey-file $PRIVKEY_FILE -pubkey-file $PUBKEY_FILE
fi

exec /app/dnstt-server -udp :$PORT -privkey-file $PRIVKEY_FILE -mtu $MTU $DNS_ZONE $FORWARD
