# Goldens Service

A Go-based gRPC service for managing golden records with PostgreSQL persistence.

## Overview

This project implements a gRPC service for managing golden records (master data). It provides a clean architecture with domain-driven design, infrastructure separation, and comprehensive testing.

## Features

- **gRPC API**: High-performance RPC communication using Protocol Buffers
- **PostgreSQL Persistence**: Reliable data storage with repository pattern
- **Docker Support**: Containerized deployment ready
- **Kubernetes Ready**: Kubernetes manifests included
- **Clean Architecture**: Domain-Driven Design with clear layer separation

## Architecture

```
cmd/app/              # Application entry point
internal/
  application/        # Application services and use cases
  domain/             # Domain models and business logic
  infrastructure/     # External dependencies (gRPC, persistence)
proto/                # Protocol Buffer definitions
deployment/           # Kubernetes manifests
```

## Requirements

- Go 1.25+
- PostgreSQL 17+
- Docker & Docker Compose
- Kubernetes (for production deployment)

## Quick Start

### Local Development

```bash
# Start PostgreSQL and the service
make start

# Run tests
make test

# Run tests with verbose output
make test-v

# Stop services
make stop
```

### Using Docker Compose

```bash
docker-compose up -d
```

### Using Makefile Commands

```bash
make help              # Show all available commands
make start             # Start PostgreSQL and the service
make stop              # Stop the service
make test <package>    # Run tests for a specific package
make build <package>   # Build a specific package
make proto             # Generate protobuf code
make clone             # Clone service template
make destroy           # Remove artifacts and stop PostgreSQL
```

## Configuration

Configuration is managed through the `hooks/config.yaml` file. Key settings:

- Database connection (PostgreSQL)
- gRPC server port
- Application logging

## API Documentation

The service exposes a gRPC API defined in [`proto/golden.proto`](proto/golden.proto). Use tools like `grpcurl` or `evans` to interact with the API.

### Example gRPC Call

```bash
# After starting the service
./bin/app/test-grpc.sh
```

## Deployment

### Docker

```bash
docker build -t goldens-service .
docker run -p 8080:8080 goldens-service
```

### Kubernetes

```bash
kubectl apply -f deployment/kubernetes/
```

See [`deployment/kubernetes/manifest.yaml`](deployment/kubernetes/manifest.yaml) for the complete deployment configuration.

## Testing

```bash
# Run tests for a specific package
make test ./internal/domain/

# Run tests with verbose output
make test-v

# Build a specific package
make build ./cmd/...
```

## Project Structure

| Directory | Description |
|-----------|-------------|
| `cmd/app/` | Main application entry point |
| `internal/application/` | Application services layer |
| `internal/domain/` | Domain entities and business rules |
| `internal/infrastructure/grpc/` | gRPC server implementation |
| `internal/infrastructure/persistence/` | Database repositories |
| `proto/` | Protocol Buffer definitions |
| `deployment/` | Deployment configurations |
| `bin/app/` | Utility scripts |

## Contributing

1. Fork the repository
2. Create a feature branch
3. Run tests to ensure nothing is broken
4. Submit a pull request

## License

See [CHANGELOG.md](CHANGELOG.md) for version history and release notes.

---

For the Spanish version, see [README.es.md](README.es.md)
