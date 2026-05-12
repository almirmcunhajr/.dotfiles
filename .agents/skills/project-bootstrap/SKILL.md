---
name: project-bootstrap
description: >
  Bootstrap a new project at Incognia using the IaC Project Bootstrap workflow.
  Use this skill whenever someone wants to create a new project, service, or
  microservice at Incognia, set up a new repository with CI/CD, provision cloud
  infrastructure, or asks about the project bootstrapping process. Also trigger
  when someone mentions "bootstrap", "new project", "new service", "new repo",
  "project setup", or needs help filling out the IaC bootstrap issue template.
---

# Project Bootstrap at Incognia

This skill guides users through bootstrapping a new project at Incognia. The process uses the **IaC Project Bootstrap** issue template in the `inloco/infra-as-code` GitHub repository. Submitting the issue triggers automation that provisions the GitHub repo, CI/CD pipelines, container registries, Kubernetes namespaces, and secrets management.

## The Three Steps

### Step 1: Create the Bootstrap Issue

Gather the required information from the user, then create the issue directly using `gh`:

```bash
gh issue create \
  --repo inloco/infra-as-code \
  --template iac-project-bootstrap.yaml \
  --field project-name="<value>" \
  --field team="<value>" \
  --field owner="<value>" \
  --field clusters="<value>" \
  --field codeowners="<value>" \
  --field images="<value>" \
  --field buildArtifactsPaths="<value>" \
  --field ciToolsSetup="<value>" \
  --field CIDependencies="<value>"
```

Omit optional `--field` flags that the user doesn't need (they'll use defaults). Always confirm the final command with the user before running it.

**Required fields:**
- **project-name** -- lowercase letters, digits, underscores, and hyphens only (e.g., `magical-data-analyzer`)
- **team** -- the team responsible for the project. Valid options: `sre`, `security`, `infrastructure`, `data-engineering`, `api`, `sdk`, `dashboard`, `data-analytics`, `data-science`, `sales-engineers`, `product-management`, `privacy`, `location`, `insights`, `customer-success`
- **owner** -- Incognia username of the resource owner (e.g., `merlin.ambrosius`)

**Optional fields** (ask about these -- they matter for CD and CI setup):
- **clusters** -- Kubernetes clusters for deployment (multi-select). If left empty, CD won't be configured. Valid options: `Global-Product`, `Global-SRE`, `Global-FortKnox`, `Global-Continuous`, `Global-DataEngineering`, `GlobalStaging-Product`, `GlobalStaging-FortKnox`, `CoreEngineering`
- **codeowners** -- GitHub `CODEOWNERS` content (e.g., `* @inloco/mages`). Defaults to `* <owner team>-codeowners`.
- **images** -- Container image names, one per line. Each must start with `incognia/<project-name>/`. Defaults to a single `incognia/<project-name>` image.
- **buildArtifactsPaths** -- Glob patterns for build artifacts retained by CI and passed to CD (e.g., `images.tar`, `artifacts/potions/*`). Defaults to `image.tar`.
- **ciToolsSetup** -- YAML mapping of tool versions for CI. Supported: `go`, `java`, `node`, `python`, `ruby`, `dotnet`. Example:
  ```yaml
  python: "3.14.15"
  go: "1.23.4"
  ```
- **CIDependencies** -- Private org repos your code imports (repo name only, no org prefix). One per line.

### Step 2: Automated Provisioning

After the issue is submitted, automation creates a PR with a `project.yaml` definition. Merging that PR provisions:

- **GitHub repo** with branch protection, team access, and CODEOWNERS
- **CI workflows** in the repo with lint, test, and build jobs pre-configured for the specified toolchains
- **CD pipelines** with deployment DAGs targeting the chosen clusters (with optional approval gates and Slack notifications)
- **Amazon ECR** encrypted container image repositories
- **Kubernetes namespaces** on target clusters
- **AWS KMS keys (SOPS)** for secrets management, plus read/sync role bindings

### Step 3: Manual Configuration in the New Repository

After the bootstrap PR is merged and resources are live, the developer must configure two things in the new repo:

#### 3a. CI Make Rules

The CI pipeline calls three make targets: `ci/lint`, `ci/test`, and `ci/build`. Define these in the root `Makefile`. The Makefile acts as an abstraction layer -- CI doesn't care about the language, it just runs `make ci/test`.

**Go example:**
```makefile
IMAGE_NAME=incognia/<project-name>

test:
	go test -v ./...
.PHONY: test

lint:
	go vet -v ./...
.PHONY: lint

docker/build:
	docker build -t $(IMAGE_NAME) .
.PHONY: docker/build

docker/save:
	docker save -o image.tar $(IMAGE_NAME)
.PHONY: docker/save

ci/build: docker/build docker/save
.PHONY: ci/build

ci/test: test
.PHONY: ci/test

ci/lint: lint
.PHONY: ci/lint
```

**Java example:**
```makefile
test:
	./gradlew --no-daemon --build-cache test
.PHONY: test

lint:
	./gradlew --no-daemon --build-cache spotlessCheck
.PHONY: lint

build:
	./gradlew --no-daemon --parallel --build-cache jibBuildTar
.PHONY: build

ci/build: build
.PHONY: ci/build

ci/test: test
.PHONY: ci/test

ci/lint: lint
.PHONY: ci/lint
```

When generating a Makefile, substitute `<project-name>` with the actual project name. If the user's language isn't Go or Java, adapt the pattern accordingly -- the key contract is that `ci/lint`, `ci/test`, and `ci/build` must exist.

#### 3b. Kustomize Overlays (only if CD clusters were selected)

Set up the following directory structure under `k8s/`:

```
k8s/
├── base/
│   └── kustomization.yaml
└── environment-overlays/
    └── <aws-account-alias>/
        ├── base/
        │   └── kustomization.yaml
        └── cluster-overlays/
            └── <cluster-lower-case-name>/
                └── kustomization.yaml
```

Common AWS account aliases and cluster names:
- `incognia-production-product` with cluster `global-product`
- `incognia-staging-product` with cluster `globalstaging-product`

Each cluster overlay's `kustomization.yaml` must include **image patches** to map generic image names to the full ECR URL for that account. Do NOT specify image tags -- the CD pipeline manages versions via ArgoCD parameter overrides.

Example cluster overlay `kustomization.yaml`:
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ../../base/
images:
- name: incognia/example/a
  newName: 889818756387.dkr.ecr.us-east-1.amazonaws.com/incognia/example/a
- name: incognia/example/b
  newName: 889818756387.dkr.ecr.us-east-1.amazonaws.com/incognia/example/b
```

#### Helm Charts Inside Kustomization (optional)

If the project benefits from Helm charts, use this structure:

```
k8s/
├── base/
│   ├── Chart.yaml
│   ├── templates/
│   │   └── ...
│   └── values.yaml
└── environment-overlays/
    └── <aws-account-alias>/
        └── cluster-overlays/
            └── <cluster>/
                └── kustomization.yaml
```

Reference the chart from the cluster kustomization:
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
helmGlobals:
  chartHome: ../../../../
helmCharts:
  - name: base
    valuesInline:
      some_value: important value
```

Note: Helm chart dependencies do not work well inside kustomizations. If needed, open a ticket on `#help-sre`.

## Workflow Summary

When helping a user bootstrap a project:

1. **Gather requirements** -- ask for project name, team, owner, language, and whether they need CD
2. **Create the issue** -- use `gh issue create` with the gathered fields. Always show the command and confirm before running.
3. **After provisioning** -- help them create the Makefile and Kustomize overlays in their new repo
4. If they already have a repo and just need help with the Makefile or Kustomize setup, jump directly to Step 3
