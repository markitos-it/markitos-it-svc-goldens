#!/bin/bash

set -e

cd "$(dirname "$0")/../.."

export GRPC_PORT=${GRPC_PORT:-3000}
export GRPC_TLS_ENABLED=${GRPC_TLS_ENABLED:-false}
export DB_HOST=${DB_HOST:-localhost}
export DB_PORT=${DB_PORT:-55432}
export DB_USER=${DB_USER:-markitos-it-svc-goldens}
export DB_PASS=${DB_PASS:-markitos-it-svc-goldens}
export DB_NAME=${DB_NAME:-markitos-it-svc-goldens}

BASE_DB_NAME="$DB_NAME"
TEST_DB_NAME=${TEST_DB_NAME:-${BASE_DB_NAME}_test_$(date +%s)}

cleanup() {
	echo "🧹 Cleaning temporary test database and postgres container..."
	docker compose exec -T markitos-it-svc-goldens-postgres dropdb --if-exists --force -h localhost -p "$DB_PORT" -U "$DB_USER" "$TEST_DB_NAME" >/dev/null 2>&1 || true
	docker compose down -v --remove-orphans markitos-it-svc-goldens-postgres >/dev/null 2>&1 || true
}
trap cleanup EXIT

make proto
docker compose up -d markitos-it-svc-goldens-postgres

echo "⏳ Waiting for PostgreSQL to become ready..."
for i in {1..90}; do
	health_status=$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' markitos-it-svc-goldens-postgres 2>/dev/null || true)
	if [ "$health_status" = "healthy" ]; then
		break
	fi

	if docker compose exec -T markitos-it-svc-goldens-postgres \
		pg_isready -h localhost -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" >/dev/null 2>&1; then
		break
	fi

	if [ "$i" -eq 90 ]; then
		echo "❌ PostgreSQL did not become ready in time"
		exit 1
	fi

	sleep 1
done

echo "🧪 Creating isolated test database: $TEST_DB_NAME"
docker compose exec -T markitos-it-svc-goldens-postgres dropdb --if-exists --force -h localhost -p "$DB_PORT" -U "$DB_USER" "$TEST_DB_NAME" >/dev/null 2>&1 || true
docker compose exec -T markitos-it-svc-goldens-postgres createdb -h localhost -p "$DB_PORT" -U "$DB_USER" "$TEST_DB_NAME"
export DB_NAME="$TEST_DB_NAME"

echo "🚀 Starting markitos-it-svc-goldens (Go)..."
echo "📡 GRPC_PORT.......: $GRPC_PORT"
echo "📦 DB_HOST.........: $DB_HOST:$DB_PORT"
echo "📦 DB_USER.........: $DB_USER"
echo "📦 DB_NAME(base)...: $BASE_DB_NAME"
echo "📦 DB_NAME(test)...: $DB_NAME"
echo "📡 GRPC_TLS_ENABLED: $GRPC_TLS_ENABLED"
echo ""

go test -cover -count=1 ./... -v