---
name: iac-project-config
description: >
  Configure Incognia IaC projects by editing the project.yaml file in the
  inloco/infra-as-code repository. Use this skill whenever someone needs to
  modify CI/CD settings, add deployment clusters, change GitHub repo settings,
  configure CI runners or resources, set up SOPS encryption, add S3 bucket
  access, configure ECR access, add workflow extensions, update access control,
  or change any infrastructure configuration for an existing Incognia project.
  Also trigger when someone mentions "project.yaml", "infra-as-code config",
  "IaC config", "deployment configuration", "CI runners", "CD applications",
  or asks how to change any project infrastructure setting.
---

# IaC Project Configuration

This skill helps configure Incognia projects by editing the `project.yaml` file in the `inloco/infra-as-code` repository. Every Incognia project has a `project.yaml` that defines its CI/CD pipelines, GitHub repo settings, container registries, Kubernetes deployments, and secrets management.

Changes to `project.yaml` are applied via PR to `inloco/infra-as-code`. When merged, automation provisions or updates the infrastructure accordingly.

## project.yaml Structure

```yaml
apiVersion: incognia.com/v1alpha1
kind: IaC
metadata:
  name: <project-name>    # lowercase, digits, underscores, hyphens only
spec:
  team: <team-name>        # required
  owner: <incognia-user>   # required
  ci:    ...               # Continuous Integration config
  cd:    ...               # Continuous Deployment config
  github: ...              # GitHub repository settings
```

The three required fields are `metadata.name`, `spec.team`, and `spec.owner`. Everything else has sensible defaults.

## Common Configuration Tasks

### Add or change deployment clusters

Each cluster is an entry under `spec.cd.applications`. The `dependencies` field creates a deployment DAG -- staging deploys first, production only after staging succeeds.

```yaml
spec:
  cd:
    applications:
      - cluster: GlobalStaging-Product
        requiresDeployApproval: false
        requiresRollbackApproval: false
      - cluster: Global-Product
        dependencies:
          - GlobalStaging-Product
```

Available clusters: `Global-Product`, `Global-SRE`, `Global-FortKnox`, `Global-Continuous`, `Global-DataEngineering`, `GlobalStaging-Product`, `GlobalStaging-FortKnox`, `CoreEngineering`.

### Configure CI tool versions

Tool setups go under the workflow parameters for each job (tests, build, lint). Supported tools: `go`, `java`, `node`, `python`, `ruby`, `dotnet`.

```yaml
spec:
  ci:
    workflow:
      parameters:
        tests:
          setups:
            - tool: java
              version: '21'
            - tool: go
              version: '1.25'
          docker: true    # enable Docker-in-Docker if needed
        build:
          setups:
            - tool: java
              version: '21'
```

### Customize CI runner resources

When builds need more CPU, memory, or storage than the defaults:

```yaml
spec:
  ci:
    runners:
      ci:
        enabled: false        # disable the default runner
      ciDocker:
        resources:
          requests:
            cpu: 1
            storage: 32Gi
          limits:
            memory: 6Gi
            ephemeralStorage: 2Gi
```

Runner types: `ci` (standard), `ciDocker` (Docker-enabled), `ciCodeql` (CodeQL analysis).

### Add workflow extensions

Extensions are extra GitHub Actions steps injected into CI jobs. They run before (`pre`) or after (`post`) the main job step.

```yaml
spec:
  ci:
    workflow:
      parameters:
        build:
          extensions:
            - name: Install ko
              uses: ko-build/setup-ko@v0.6
              hook: pre
        tests:
          extensions:
            - name: Start test database
              run: docker compose up -d postgres
              hook: pre
```

### Configure access control

Control who can deploy and who can view:

```yaml
spec:
  cd:
    accessControl:
      readSync:          # can access, approve, and sync
        - api:eng-0
        - api:eng-1
      readOnly:          # can only view
        - sdk:eng-0
```

### Enable SOPS (secrets management)

Creates a KMS key per deployment environment:

```yaml
spec:
  cd:
    sops:
      enabled: true
```

### Grant CI/CD access to S3 buckets

```yaml
spec:
  ci:
    s3BucketAccess:
      - awsAccountAlias: incognia-production-product
        bucketName: my-bucket
        paths:
          - "data/*"
  cd:
    s3BucketAccess:
      - awsAccountAlias: incognia-production-product
        bucketName: my-bucket
        paths:
          - "releases/*"
        put: true         # allow uploads (CD only)
```

### Grant CI access to ECR repositories

```yaml
spec:
  ci:
    ecrAccess:
      - awsAccountAlias: incognia-production-product
        repository: incognia/some-base-image
```

### Configure GitHub repository settings

```yaml
spec:
  github:
    requiredApprovingReviewCount: 2
    deleteBranchOnMerge: true
    allowSquashMerge: true
    allowMergeCommit: false
    codeowners: |
      * @inloco/my-team
      /src/special @specific-reviewer
    permissions:
      pull:
        - developers
```

### Add Grafana dashboard links to deploy notifications

```yaml
spec:
  cd:
    grafanaDashboards:
      - name: Service Dashboard
        url: https://grafana.incognia.com/d/abc123
```

### Configure custom artifact paths

When your build produces something other than `image.tar`:

```yaml
spec:
  ci:
    workflow:
      parameters:
        artifactsPaths:
          - '**/build/jib-image.tar'
```

### Disable default CI/CD workflows (use custom)

```yaml
spec:
  ci:
    workflow:
      enabled: false    # provide your own CI workflow
  cd:
    workflow:
      enabled: false    # provide custom Argo WorkflowTemplate
```

## Full Specification Reference

For the complete list of all fields, types, defaults, and constraints, read `references/project-yaml-spec.md` in this skill's directory. Consult it whenever you need details about a field not covered in the common tasks above.

## Workflow

When a user asks to configure a project:

1. **Find the project.yaml** -- it's at `projects/<project-name>/project.yaml` in the `inloco/infra-as-code` repo. Ask for the project name if not provided.
2. **Understand what they want to change** -- map their request to the relevant spec fields.
3. **Edit the YAML** -- apply changes preserving the existing structure. Only modify the fields that need changing.
4. **Create a PR** -- changes go through a PR to `inloco/infra-as-code`. Use `gh` to create the PR if the user wants.

If the user is unsure about valid values (cluster names, runner types, etc.), refer to the common tasks section above or the full spec reference.
