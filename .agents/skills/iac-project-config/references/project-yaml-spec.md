# IaC Project Specification - Full Field Reference

This document contains the complete `project.yaml` specification for Incognia IaC projects.
Read this when you need details about a specific field, its type, constraints, or default value.

## Table of Contents
- [metadata](#metadata)
- [spec.team / spec.owner](#core-fields)
- [spec.ci](#continuous-integration)
  - [s3BucketAccess](#cis3bucketaccess)
  - [ecrAccess](#ciecraccess)
  - [dependencies](#cidependencies)
  - [runners](#cirunners)
  - [workflow](#ciworkflow)
  - [workflow.parameters (lint/tests/build)](#ciworkflowparameters)
  - [extensions](#extensions)
- [spec.cd](#continuous-deployment)
  - [s3BucketAccess](#cds3bucketaccess)
  - [s3Uploads](#cds3uploads)
  - [applications](#cdapplications)
  - [accessControl](#cdaccesscontrol)
  - [sops](#cdsops)
  - [images](#cdimages)
  - [workflow](#cdworkflow)
  - [executor](#cdexecutor)
  - [maven](#cdmaven)
  - [grafanaDashboards](#cdgrafanadashboards)
- [spec.github](#github)

---

## metadata

### `metadata.name`
- **Type**: `String`
- **Required**: Yes
- **Constraints**: Only lowercase letters (a-z), digits (0-9), underscores (`_`), and hyphens (`-`).

## Core Fields

### `spec.team`
- **Type**: `String`
- **Required**: Yes
- **Constraints**: Only lowercase letters, digits, underscores, hyphens.

### `spec.owner`
- **Type**: `String`
- **Required**: Yes
- **Description**: The owner's Incognia username.

---

## Continuous Integration

### `spec.ci.enabled`
- **Type**: `Boolean` — **Default**: `true`

### `spec.ci.s3BucketAccess`
- **Type**: `List` — Grants CI runners read-only access to S3 bucket paths.
- Each item: `awsAccountAlias` (String), `bucketName` (String), `paths` (List\<String\>, supports wildcards)

### `spec.ci.ecrAccess`
- **Type**: `List` — Grants CI runners read-only access to ECR repositories.
- Each item: `awsAccountAlias` (String), `repository` (String)

### `spec.ci.dependencies`
- **Type**: `List` — Private org repos required by CI (repo name only, no org prefix).

### `spec.ci.runners`
- **Type**: `Dictionary` — Defines CI runners.
- Runner types: `ci` (tests/builds), `ciDocker` (Docker-enabled), `ciCodeql` (CodeQL analysis)

### `spec.ci.runners.<runner>.enabled`
- **Type**: `Boolean` — **Default**: `true`

### `spec.ci.runners.<runner>.resources`
- `requests.cpu`: CPU units (String/Integer/Float)
- `requests.storage`: Storage (Kubernetes memory units)
- `limits.memory`: Memory limit (Kubernetes memory units)
- `limits.ephemeralStorage`: Ephemeral storage limit (Kubernetes memory units)

### `spec.ci.workflow.enabled`
- **Type**: `Boolean` — **Default**: `true`
- Set to `false` for custom CI workflows.

### `spec.ci.workflow.parameters`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `debug` | Boolean | `false` | Enable debug mode |
| `submodules` | Boolean | `true` | Enable submodule pulls |
| `artifactsPaths` | List | `[image.tar]` | Paths for CI artifacts |

### `spec.ci.workflow.parameters.lint`
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | Boolean | `true` | Enable lint job |
| `docker` | Boolean | `false` | Run lint in Docker environment |
| `required` | Boolean | `true` | Block PRs on failure |
| `kubeLinter.enabled` | Boolean | `true` | Enable kube-linter |

### `spec.ci.workflow.parameters.tests`
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | Boolean | `true` | Enable test job |
| `docker` | Boolean | `false` | Run tests in Docker environment |
| `required` | Boolean | `true` | Block PRs on failure |

### `spec.ci.workflow.parameters.build`
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | Boolean | `true` | Enable build job |

### `spec.ci.workflow.parameters.(tests|build|lint).setups[]`
- `tool` (String, required): One of `go`, `java`, `node`, `python`, `ruby`, `dotnet`
- `version` (String, required): Tool version

### Extensions

`spec.ci.workflow.parameters.(tests|build|lint|release).extensions[]`:
| Field | Type | Description |
|-------|------|-------------|
| `name` | String (required) | Step name |
| `uses` | String | Reference to existing GitHub Action |
| `with` | Dictionary | Parameters for the action |
| `run` | String | Shell command (max 21,000 chars) |
| `env` | Dictionary | Environment variables (not available for lint) |
| `hook` | String (`pre`/`post`, default `pre`) | Execute before or after the job step |

---

## Continuous Deployment

### `spec.cd.enabled`
- **Type**: `Boolean` — **Default**: `true`

### `spec.cd.s3BucketAccess`
- **Type**: `List` — Grants CD workflows access to S3 buckets.
- Each item: `awsAccountAlias`, `bucketName`, `paths` (List\<String\>), `put` (Boolean, default `false`), `delete` (Boolean, default `false`)

### `spec.cd.s3Uploads`
- **Type**: `List` — File/directory uploads to S3 during CD.
- Each item: `awsAccountAlias`, `origin` (local path relative to artifactsPaths), `destination` (S3 path like `s3://bucket/prefix/`)
- Requires matching `s3BucketAccess` configuration.

### `spec.cd.releaseChannelName`
- **Type**: `String` — **Default**: `releases-<team-name>`
- Slack channel for deployment notifications.

### `spec.cd.applications[]`
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `cluster` | String (required) | — | Kubernetes cluster |
| `namespace` | String | project name | Kubernetes namespace |
| `targetRevision` | String | default branch | Branch that triggers CD |
| `releaseChannelName` | String | `releases-<team>` | Overrides top-level channel |
| `additionalNamespaces` | List | — | Extra namespaces |
| `dependencies` | List | — | Deployment DAG dependencies |
| `requiresDeployApproval` | Boolean | `true` | Manual approval before deploy |
| `requiresRollbackApproval` | Boolean | `true` | Manual approval before rollback |
| `syncPolicy` | ArgoCD SyncPolicy | — | ArgoCD sync policy |
| `ignoreDifferences` | ArgoCD IgnoreDifferences | — | ArgoCD ignore differences |
| `clusterResourceAllowList` | ArgoCD ClusterResourceWhitelist | — | Allowed cluster resources |

### `spec.cd.accessControl`
- `readSync` (List): Roles with access + approve + sync permissions
- `readOnly` (List): Roles with read-only access

### `spec.cd.sops`
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `enabled` | Boolean | `false` | Enable SOPS (creates KMS key per environment) |
| `kmsKeyOverrides[]` | List | `[]` | Override KMS key settings |

`kmsKeyOverrides[]` items: `awsAccountAlias`, `awsRegion`, `alias` (defaults to `sops-<project-name>`), `id` (for importing existing keys)

### `spec.cd.images[]`
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `awsAccountAlias` | String | Yes | AWS account alias |
| `awsRegion` | String | Yes | AWS region |
| `names` | List | Yes | Image names |
| `encryptionConfigutation.encryptionType` | String | — | Default `KMS` |

If omitted, infers `incognia/<project-name>` for each environment.

### `spec.cd.workflow`
- `enabled` (Boolean, default `true`): If false, define custom Argo WorkflowTemplate in k8s overlays.
- `parameters.push.enabled` (Boolean): Enable push in CD workflow.

### `spec.cd.executor`
- `policies[]`: Additional IAM policies for CD executor. Each: `name` (String), `policy` (String).

### `spec.cd.maven`
- `enabled` (Boolean, default `true`): Enable Maven publishing.
- `skipTasks` (List): Gradle tasks to skip when publishing.
- Requires S3 bucket access configured via `spec.cd.s3BucketAccess`.

### `spec.cd.grafanaDashboards[]`
- `name` (String, default `Dashboard`): Display name in notification.
- `url` (String, required): Grafana dashboard URL.

---

## GitHub

### `spec.github`
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `repositoryName` | String | project name | Rename the repo |
| `allowForcePush` | Boolean | `false` | Allow force push |
| `dismissStaleReviewsOnPush` | Boolean | `true` | Dismiss stale reviews on push |
| `requireLastPushApproval` | Boolean | `true` | Last push must be approved by another person |
| `requiredApprovingReviewCount` | Integer | `1` | Required approvals |
| `requiredReviewThreadResolution` | Boolean | `true` | All threads must be resolved |
| `allowAutoMerge` | Boolean | `true` | Allow auto-merge |
| `allowMergeCommit` | Boolean | `true` | Allow merge commits |
| `allowRebaseMerge` | Boolean | `true` | Allow rebase merges |
| `allowSquashMerge` | Boolean | `true` | Allow squash merges |
| `allowUpdateBranch` | Boolean | `false` | Suggest updating PR branches |
| `deleteBranchOnMerge` | Boolean | `false` | Auto-delete head branch |
| `codeowners` | String | team's code owners | CODEOWNERS content |
| `additionalStatusChecks` | List | — | Extra CI status checks |

### `spec.github.permissions`
- `enabled` (String): Whether to manage permissions.
- `dev` (List\<String\>): Groups allowed to push. Owner team is auto-assigned.
- `pull` (List\<String\>): Groups allowed to pull/view.
