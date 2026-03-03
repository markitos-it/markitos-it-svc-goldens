.DEFAULT_GOAL := help

.PHONY: help proto start stop purge deploy-tag delete-tag clone

help:
	@echo "📋 Available commands (LOCAL DEVELOPMENT):"
	@echo ""
	@echo "  🚀 DESARROLLO:"
	@echo "  make start               	- Start app with go run (inicia PostgreSQL)"
	@echo "  make stop               	- Stop app with go run (para PostgreSQL)"
	@echo "  make test <package>       	- Run tests for a specific package (e.g., make test ./internal/domain/...)"
	@echo "  make build <package>      	- Build a specific package (e.g., make build ./cmd/...)"
	@echo ""
	@echo "  🛠️  UTILIDADES:"
	@echo "  make proto            		- Generate protobuf code"
	@echo "  make clone            		- Clone service template replacing golden/goldens"
	@echo "  make destroy          		- Remove artifacts and stop PostgreSQL"
	@echo ""
	@echo "  ☸️  KUBERNETES (deployment/):"
	@echo "  make deploy-tag <version>  - Create and push git tag (e.g., 1.2.3)"
	@echo "  make delete-tag <version>  - Delete git tag locally and remotely"
	@echo ""

proto:
	bash bin/app/proto.sh

start:
	bash bin/app/start.sh

stop:
	bash bin/app/stop.sh

destroy:
	bash bin/app/destroy.sh

deploy-tag:
	bash bin/app/deploy-tag.sh $(filter-out $@,$(MAKECMDGOALS))

delete-tag:
	bash bin/app/delete-tag.sh $(filter-out $@,$(MAKECMDGOALS))

clone:
	bash bin/app/clone.sh

test:
	go test -count=1 -cover ./... $(filter-out $@,$(MAKECMDGOALS))

build:
	go build ./... $(filter-out $@,$(MAKECMDGOALS))

%:
	@: