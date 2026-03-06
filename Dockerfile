FROM golang:1.25-alpine AS builder

WORKDIR /build

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GO111MODULE=on

RUN apk add --no-cache make git protobuf protobuf-dev bash

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest \
 && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN make proto

RUN go build -o app ./cmd/app

FROM alpine:3.22

RUN apk --no-cache add ca-certificates \
 && addgroup -S app \
 && adduser -S -G app app

WORKDIR /app

COPY --from=builder /build/app .

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 CMD pidof app >/dev/null || exit 1

USER app

CMD ["./app"]