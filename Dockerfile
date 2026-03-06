FROM golang:1.25-alpine AS builder
WORKDIR /build

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GO111MODULE=on

COPY go.mod go.sum ./
RUN apk add --no-cache bash coreutils
RUN echo "== go.mod ==" \
 && cat go.mod \
 && echo "== go.sum (first lines) ==" \
 && head -n 20 go.sum \
 && echo "== go env (module-related) ==" \
 && go env | grep -E 'GO111MODULE|GOMOD|GOMODCACHE|GOPATH|GOROOT|GOOS|GOARCH'
RUN go mod download
COPY . .

RUN echo "== pwd ==" && pwd \
 && echo "== ls -la ==" && ls -la \
 && echo "== ls -la proto ==" && ls -la proto \
 && echo "== go env GOMOD ==" && go env GOMOD \
 && echo "== grep imports of proto ==" \
 && (grep -R --line-number 'markitos-it-svc-goldens/proto' internal || true) \
 && echo "== go list ./... (first output) ==" \
 && go list ./... | head -n 50

 
RUN go build -v -x -o app ./cmd/app
FROM alpine:latest
WORKDIR /app
RUN apk --no-cache add ca-certificates
COPY --from=builder /build/app .
EXPOSE 3000
CMD ["./app"]