# Servicio Goldens

Un servicio gRPC implementado en Go para la gestión de registros golden (datos maestros) con persistencia en PostgreSQL.

## Visión General

Este proyecto implementa un servicio gRPC para la gestión de registros golden (datos maestros). Proporciona una arquitectura limpia con diseño basado en dominios, separación de infraestructura y pruebas comprehensivas.

## Características

- **API gRPC**: Comunicación RPC de alto rendimiento usando Protocol Buffers
- **Persistencia PostgreSQL**: Almacenamiento de datos confiable con patrón repositorio
- **Soporte Docker**: Listo para despliegue en contenedores
- **Listo para Kubernetes**: Manifiestos de Kubernetes incluidos
- **Arquitectura Limpia**: Diseño Dirigido por Dominios con separación clara de capas

## Arquitectura

```
cmd/app/              # Punto de entrada de la aplicación
internal/
  application/        # Servicios de aplicación y casos de uso
  domain/             # Modelos de dominio y lógica de negocio
  infrastructure/     # Dependencias externas (gRPC, persistencia)
proto/                # Definiciones de Protocol Buffers
deployment/           # Manifiestos de Kubernetes
```

## Requisitos

- Go 1.25+
- PostgreSQL 17+
- Docker y Docker Compose
- Kubernetes (para despliegue en producción)

## Inicio Rápido

### Desarrollo Local

```bash
# Iniciar PostgreSQL y el servicio
make start

# Ejecutar pruebas
make test

# Ejecutar pruebas con salida detallada
make test-v

# Detener servicios
make stop
```

### Usando Docker Compose

```bash
docker-compose up -d
```

### Comandos del Makefile

```bash
make help              # Mostrar todos los comandos disponibles
make start             # Iniciar PostgreSQL y el servicio
make stop              # Detener el servicio
make test <package>    # Ejecutar pruebas de un paquete específico
make build <package>   # Compilar un paquete específico
make proto             # Generar código protobuf
make clone             # Clonar plantilla del servicio
make destroy           # Eliminar artefactos y detener PostgreSQL
```

## Configuración

La configuración se gestiona a través del archivo `hooks/config.yaml`. Configuración principal:

- Conexión a base de datos (PostgreSQL)
- Puerto del servidor gRPC
- Registro de la aplicación

## Documentación de la API

El servicio expone una API gRPC definida en [`proto/golden.proto`](proto/golden.proto). Usa herramientas como `grpcurl` o `evans` para interactuar con la API.

### Ejemplo de Llamada gRPC

```bash
# Después de iniciar el servicio
./bin/app/test-grpc.sh
```

## Despliegue

### Docker

```bash
docker build -t goldens-service .
docker run -p 8080:8080 goldens-service
```

### Kubernetes

```bash
kubectl apply -f deployment/kubernetes/
```

Consulta [`deployment/kubernetes/manifest.yaml`](deployment/kubernetes/manifest.yaml) para la configuración completa de despliegue.

## Pruebas

```bash
# Ejecutar pruebas de un paquete específico
make test ./internal/domain/

# Ejecutar pruebas con salida detallada
make test-v

# Compilar un paquete específico
make build ./cmd/...
```

## Estructura del Proyecto

| Directorio | Descripción |
|------------|-------------|
| `cmd/app/` | Punto de entrada principal de la aplicación |
| `internal/application/` | Capa de servicios de aplicación |
| `internal/domain/` | Entidades de dominio y reglas de negocio |
| `internal/infrastructure/grpc/` | Implementación del servidor gRPC |
| `internal/infrastructure/persistence/` | Repositorios de base de datos |
| `proto/` | Definiciones de Protocol Buffers |
| `deployment/` | Configuraciones de despliegue |
| `bin/app/` | Scripts de utilidad |

## Contribuir

1. Haz un fork del repositorio
2. Crea una rama de funcionalidad
3. Ejecuta las pruebas para asegurar que nada está roto
4. Envía un pull request

## Licencia

Consulta [CHANGELOG.md](CHANGELOG.md) para el historial de versiones y notas de lanzamiento.

---

Para la versión en inglés, consulta [README.md](README.md)
