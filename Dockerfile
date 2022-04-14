ARG GOARCH=amd64

FROM golang:1.17-bullseye AS base

FROM base AS branch-arch-arm64
ENV ARCH_PROTOC=aarch_64
ENV ARCH_BUF=aarch64

FROM base AS branch-arch-amd64
ENV ARCH_PROTOC=v86_64
ENV ARCH_BUF=v86_64

FROM branch-arch-${GOARCH}

ENV GOBIN=/usr/local/bin
ENV VERSION_BUF="1.0.0-rc12"
ENV VERSION_PROTOC="3.19.4"
ENV VERSION_GO_PROTO="1.23.0"
ENV VERSION_GO_GRPC="1.1.0"

RUN apt-get update \
 && apt-get install -y build-essential curl unzip

RUN curl -sLo protoc.zip \
    "https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION_PROTOC}/protoc-${VERSION_PROTOC}-linux-${ARCH_PROTOC}.zip" \
 && unzip protoc.zip \
 && go install "google.golang.org/protobuf/cmd/protoc-gen-go@v${VERSION_GO_PROTO}" \
 && go install "google.golang.org/grpc/cmd/protoc-gen-go-grpc@v${VERSION_GO_GRPC}"

RUN curl -sLo buf.tar.gz "https://github.com/bufbuild/buf/releases/download/v${VERSION_BUF}/buf-linux-${ARCH_BUF}.tar.gz" \
 && tar -xvzf buf.tar.gz -C /usr/local --strip-components 1
 # TODO: verify file signature

WORKDIR /src
VOLUME /src
ENTRYPOINT [ "/bin/bash" ]
