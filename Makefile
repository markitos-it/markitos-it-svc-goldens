.DEFAULT_GOAL := help

.PHONY: help proto start stop purge clone test test-v cover build destroy

help:
	@echo "📋 Available commands (LOCAL DEVELOPMENT):"
	@echo ""
	@echo "  🚀 DESARROLLO:"
	@echo "  make start                 - Start app with go run (inicia PostgreSQL)"
	@echo "  make stop                  - Stop app with go run (para PostgreSQL)"
	@echo "  make test <package>        - Run tests for a specific package"
	@echo "  make test-v <package>      - Run tests with verbose output"
	@echo "  make cover <package>       - Run tests with coverage report"
	@echo "  make build <package>       - Build a specific package"
	@echo ""
	@echo "  🛠️  UTILIDADES:"
	@echo "  make proto                 - Generate protobuf code"
	@echo "  make clone                 - Clone service template replacing golden/goldens"
	@echo "  make destroy               - Remove artifacts and stop PostgreSQL"
	@echo ""
	@echo "  ☸️  KUBERNETES (deployment/):"
	@echo ""

proto:
	bash bin/app/proto.sh

start:
	bash bin/app/start.sh

stop:
	bash bin/app/stop.sh

destroy:
	bash bin/app/destroy.sh

clone:
	bash bin/app/clone.sh

test:
	bash bin/app/test.sh $(filter-out $@,$(MAKECMDGOALS))

test-v:
	bash bin/app/test-v.sh -v $(filter-out $@,$(MAKECMDGOALS))

cover:
	bash bin/app/cover.sh $(filter-out $@,$(MAKECMDGOALS))

build:
	go build ./... $(filter-out $@,$(MAKECMDGOALS))

%:
	@:
