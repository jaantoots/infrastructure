FROM alpine:3.10.3 AS build
ARG VERSION=1.0.3

# Install dependencies and prepare
RUN apk --no-progress --no-cache add go musl-dev git
RUN adduser -D -h /build -g build build
USER build

# Build caddy
COPY main.go /build/main.go
RUN cd /build && \
    export GO111MODULE=on && \
    go mod init caddy && \
    go get -v github.com/caddyserver/caddy@v${VERSION} && \
    # Black magic to get it working on CoreOS
    CGO_ENABLED=0 go build

# Create final image
FROM alpine:3.10.3

# Install caddy
RUN apk --no-progress --no-cache add ca-certificates
COPY --from=build --chown=root:root /build/caddy /usr/local/bin
RUN mkdir /srv/http
RUN addgroup -S caddy && \
    adduser -S -D -G caddy -h /var/lib/caddy -s /usr/sbin/nologin -g caddy caddy

# Configure container
EXPOSE 8080
EXPOSE 8443
USER caddy
WORKDIR /var/lib/caddy
ENV CADDYPATH /var/lib/caddy/caddy
VOLUME /var/lib/caddy /srv/http
CMD ["caddy", "-http-port", "8080", "-https-port", "8443"]
