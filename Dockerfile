# combined sops build with docker
# gives you sops command and docker command at /usr/local/bin in a single docker image


# https://github.com/mozilla/sops
FROM golang:1.12
RUN go get go.mozilla.org/sops/cmd/sops
RUN CGO_ENABLED=0 GOOS=linux go install -a -ldflags '-extldflags "-static"' go.mozilla.org/sops/cmd/sops


FROM alpine:latest
COPY --from=0 /go/bin/sops /usr/local/bin/sops
RUN \
apk add --no-cache --update ca-certificates && \
chmod +x /usr/local/bin/sops


COPY --from=docker:latest /usr/local/bin/docker /usr/local/bin/docker
RUN \
chmod +x /usr/local/bin/docker


WORKDIR /usr/local/bin
CMD ["/usr/local/bin/docker"]
