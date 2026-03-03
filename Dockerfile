FROM golang:1.25-alpine AS builder

WORKDIR /build

COPY go.* ./
RUN go mod download
RUN go mod tidy
RUN make proto

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o app cmd/app/main.go

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=builder /build/app .

EXPOSE 3000

CMD ["./app"]
