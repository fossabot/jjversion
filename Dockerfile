FROM golang:alpine AS build

ARG BUILD_VERSION
ARG VERSION=${BUILD_VERSION:-0.0.0}

WORKDIR '/app'
COPY src/go.mod ./
COPY src/go.sum ./

RUN go mod download

COPY src ./

RUN go build -ldflags "-X main.appVersion=${VERSION}"

FROM alpine:3.14.2@sha256:e1c082e3d3c45cccac829840a25941e679c25d438cc8412c2fa221cf1a824e6a
WORKDIR '/repo'
COPY --from=build /app/jjversion /usr/local/bin

CMD ["jjversion"]
