## v0.3.0 (2026-03-06)

### ✨ Features

- add cleanup function for temporary test database in cover, test, and test-v scripts ([`b39f410`])

### ♻️  Refactor

- (release) testing like a boss :P ([`d049459`])

### 📦 Other

- testing and tuning ([`8d0d4bd`])

## v0.2.2 (2026-03-06)

### 🔧 Chores

- local working tree changes: Makefile, internal/application/services/services_test.go, internal/domain/helpers_test.go, internal/infrastructure/grpc/server_test.go, internal/infrastructure/persistence/postgres/repository_test.go ([`local`])

## v0.2.2 (2026-03-06)

### 🔧 Chores

- local working tree changes: .github/workflows/secured-publish.yaml, deployment/kubernetes/manifest.yaml ([`local`])

## v0.2.1 (2026-03-06)

### 🔧 Chores

- local working tree changes: deployment/kubernetes/manifest.yaml, deployment/kubernetes/postgres.yaml ([`local`])

## v0.2.0 (2026-03-06)

### ♻️  Refactor

- (release) using version semver at deploy ([`773f7e8`])
- (release) release v0.1.0: update .github/workflows/appsec.yaml.off and .github/workflows/publish-image.yaml.off ([`2dfff46`])

## v0.1.0 (2026-03-06)

### ♻️  Refactor

- (release) release v0.1.0: update .github/workflows/appsec.yaml.off and .github/workflows/publish-image.yaml.off ([`2dfff46`])

## v0.1.0 (2026-03-06)

### 🔧 Chores

- local working tree changes: .github/workflows/appsec.yaml.off, .github/workflows/publish-image.yaml.off ([`local`])

## v0.1.0 (2026-03-06)

### ✨ Features

- (release) release v0.4.0: update .github/workflows/secured-publish.yaml, cmd/app/main.go and 1 more files ([`ded777a`])
- (release) snyk to appsec replace checkov and semgrep ([`9aef459`])
- (release) release v0.2.0: remove deprecated appsec and publish-image workflows; added secured pipeline to publish only ([`39b4dfb`])
- (workflows) remove deprecated appsec and publish-image workflows; add secured-publish workflow for enhanced security ([`78305d2`])
- (release) release v0.1.0: reset versioning; remove redundant make proto command from build process; markitos-it/markitos-it-svc-golden; +24 more changes ([`438b19d`])
- (release) release v0.1.0: remove redundant make proto command from build process; markitos-it/markitos-it-svc-golden; update build process to include go mod tidy and make proto; +16 more changes ([`9a2a599`])
- (release) release v0.1.0: Add workflow for publishing Docker image to GCP Artifact…; Enhance security context for deployments and secrets in K…; Enhance Gitleaks detection verbosity in appsec.yml; +10 more changes ([`dd76ce9`])

### 🐛 Bug Fixes

- (release) release v0.4.1: update .github/workflows/secured-publish.yaml and bin/app/proto.sh ([`6f73eed`])
- (release) release v0.3.5: update go.mod ([`da28a1f`])
- (release) appsec tuning ([`555a83d`])
- (release) release v0.3.3: update .github/workflows/secured-publish.yaml ([`bb6626d`])
- (release) release v0.3.2: update .github/workflows/secured-publish.yaml ([`2bcccff`])
- (release) release v0.3.1: update .github/workflows/secured-publish.yaml ([`04124e6`])
- (release) appsec fixing ([`26626da`])
- (release) appsec fixing. release v0.2.3 ([`5eb0d5c`])
- (release) release v0.2.2: update .github/workflows/secured-publish.yaml and deployment/kubernetes/manifest.yaml ([`6796c21`])
- (release) release v0.2.2: update deployment/kubernetes/manifest.yaml ([`3d6c628`])
- (release) release v0.2.1: appsec-fixupdate cmd/app/main.go and deployment/kubernetes/postgres.yaml ([`da5c7db`])
- (release) release v0.1.6: update Dockerfile ([`9a73e70`])
- (release) release v0.1.5: update bin/app/proto.sh ([`d4271a0`])
- (release) release v0.1.4: update Dockerfile ([`bec6007`])
- (release) release v0.1.3: update Dockerfile ([`68702b5`])
- (release) release v0.1.2: update Dockerfile and bin/app/proto.sh ([`7b571f9`])
- (release) release v0.1.1: update Dockerfile ([`18dac25`])
- (Dockerfile) remove redundant make proto command from build process ([`fbb462e`])
- (Dockerfile) update build process to include go mod tidy and make proto ([`984a50c`])
- (release) release v0.1.1: update .github/workflows/appsec.yaml.off, .github/workflows/appsec.yml and 1 more files ([`3d0d0f9`])

### 📦 Other

- reset versioning ([`c38a1eb`])
- markitos-it/markitos-it-svc-golden ([`2f1d2c3`])
- Add workflow for publishing Docker image to GCP Artifact Registry ([`e370ba8`])
- Enhance security context for deployments and secrets in Kubernetes manifests ([`778b8a0`])
- Enhance Gitleaks detection verbosity in appsec.yml ([`c937a09`])
- Add comments to skip Checkov secrets for local development in docker-compose.yml ([`5cf995a`])
- Add GitHub Actions workflows for application security and Docker image publishing ([`00a7940`])
- naming refinement ([`7ac75ae`])
- fix destroy names ([`27b22a9`])
- test with grpcurl manually to see howto use as client ([`bde2d70`])
- refactor and clean code ([`f44d2fd`])
- first  base for goden template ([`b127457`])
- thin base, best arch ([`bdfa207`])
- making golden go service template ([`584a699`])
- Initial commit ([`d708ce3`])
- Update Dockerfile to build with make proto ([`20fce26`])

