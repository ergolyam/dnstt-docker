ARG VERSION=v1.20260501.0

FROM docker.io/golang:1.26-alpine3.23 AS builder

ARG VERSION

WORKDIR /build

RUN wget -O source.tar.gz https://repo.or.cz/dnstt.git/snapshot/refs/tags/$VERSION.tar.gz

RUN tar xfv source.tar.gz --strip-components=1

WORKDIR /build/dnstt-server

RUN go build && \
    mkdir /app && \
    cp /build/dnstt-server/dnstt-server /app/dnstt-server && \
    rm -rf /build/*


FROM docker.io/busybox:stable-uclibc AS main

COPY --from=builder /app /app

COPY ./entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]
