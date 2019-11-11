FROM alpine:3.10.3 AS build

# Install dependencies and prepare
RUN apk --no-progress --no-cache add go musl-dev git
RUN adduser -D -g build build
USER build

# Build caddy
COPY main.go /home/build/main.go
RUN cd /home/build && \
    export GO111MODULE=on && \
    go mod init caddy && \
    go get github.com/caddyserver/caddy && \
    # Black magic to get it working on CoreOS
    CGO_ENABLED=0 go build

# Create final image
FROM alpine:3.10.3

# Install caddy
RUN apk --no-progress --no-cache add ca-certificates
COPY --from=build --chown=root:root /home/build/caddy /usr/local/bin
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
