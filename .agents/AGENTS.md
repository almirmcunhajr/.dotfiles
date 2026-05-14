# Global Agent Instructions

## Pre-Implementation Protocol

1. **Read the codebase** to understand the existing structure, dependencies, and patterns.
2. **Load foundational skills**: `clean-code`, `architecture-patterns`, and the language's foundational skills from the table.
3. **Enter plan mode**. Throughout the plan, as each concern is identified:
   1. Consult the Skill Lookup Table and list every skill to load for that concern.
   2. Load those skills before conceiving any implementation for that concern.
   This is an iterative process — new concerns may emerge at any stage of the plan and must trigger a new skill-loading pass.

## Skill Lookup Table

### Any language

| If the task will involve… | Load upfront |
|---------------------------|--------------|
| Any code change | `clean-code`, `architecture-patterns` |

### Go

| If the task will involve… | Load upfront |
|---------------------------|--------------|
| Any Go code | `golang-design-patterns`, `golang-code-style`, `golang-naming`, `golang-structs-interfaces` |
| Creating, wrapping, or propagating errors at any point | `golang-error-handling` |
| Error handling and the codebase uses `github.com/samber/oops` | `golang-samber-oops` |
| Writing, modifying, or reviewing tests | `golang-testing`, `golang-stretchr-testify` |
| Concurrent operations, background processing, or shared state | `golang-concurrency`, `golang-context` |
| Request lifecycles, cancellation, or timeout propagation | `golang-context` |
| Reading from or writing to a database | `golang-database` |
| Building or modifying a CLI tool | `golang-cli`, `golang-spf13-cobra` |
| CLI and the codebase uses `github.com/spf13/cobra` | `golang-spf13-cobra` |
| App configuration, env vars, or settings at any point | `golang-spf13-viper` |
| Adding, removing, or updating packages | `golang-dependency-management` |
| Wiring dependencies between services or components | `golang-dependency-injection` |
| DI and the codebase uses `go.uber.org/fx` | `golang-uber-fx` |
| DI and the codebase uses `go.uber.org/dig` | `golang-uber-dig` |
| DI and the codebase uses `github.com/google/wire` | `golang-google-wire` |
| DI and the codebase uses `github.com/samber/do` | `golang-samber-do` |
| gRPC communication, proto definitions, or interceptors | `golang-grpc` |
| A GraphQL API | `golang-graphql` |
| API documentation or OpenAPI/Swagger specs | `golang-swagger` |
| Logging, metrics, or distributed tracing | `golang-observability` |
| Logging and the codebase uses `github.com/samber/slog-*` | `golang-samber-slog` |
| Performance-sensitive code, profiling, or benchmarking | `golang-performance`, `golang-benchmark` |
| User-supplied input, secrets, cryptography, or external data | `golang-security`, `golang-safety` |
| Nil-able types, type assertions, or concurrent state mutations | `golang-safety` |
| CI workflows, linting pipelines, or automated checks | `golang-continuous-integration` |
| Processing collections, slices, or maps at scale | `golang-data-structures` |
| Functional transforms on collections and the codebase uses `github.com/samber/lo` | `golang-samber-lo` |
| In-memory caching with eviction or TTL | `golang-samber-hot` |
| Optional or result types and the codebase uses `github.com/samber/mo` | `golang-samber-mo` |
| Reactive or event-driven data pipelines and the codebase uses `github.com/samber/ro` | `golang-samber-ro` |
| Choosing or comparing libraries for a feature | `golang-popular-libraries` |
| Linting setup or golangci-lint configuration | `golang-lint` |
| Creating a new project, module, or monorepo layout | `golang-project-layout` |
| Writing or updating godoc, README, or CHANGELOG | `golang-documentation` |
| Upgrading the Go version or adopting newer language features | `golang-modernize`, `golang-stay-updated` |
| Diagnosing crashes, deadlocks, data races, or unexpected behavior | `golang-troubleshooting` |

### Python

| If the task will involve… | Load upfront |
|---------------------------|--------------|
| Any Python code | `python-design-patterns`, `python-code-style` |
| Reading env vars, settings, or configuration at any point | `python-configuration` |
| Input validation, error propagation, or user-facing error messages | `python-error-handling` |
| Writing, modifying, or reviewing tests | `python-testing-patterns` |
| Introducing new types, generics, protocols, or strict type checking | `python-type-safety` |
| I/O-bound operations, async endpoints, or concurrent processing | `async-python-patterns` |
| Deferred, long-running, or background task processing | `python-background-jobs` |
| Logging, metrics, tracing, or production observability | `python-observability` |
| Calls to external services, APIs, or unreliable dependencies | `python-resilience` |
| Managing connections, file handles, or resource cleanup | `python-resource-management` |
| Performance-sensitive code or heavy data processing | `python-performance-optimization` |
| Creating a distributable library, package, or CLI tool | `python-packaging` |
| Creating a new module, service, or restructuring the codebase | `python-project-structure` |
| Reviewing or refactoring existing Python code | `python-anti-patterns` |

### Flutter

| If the task will involve… | Load upfront |
|---------------------------|--------------|
| Any Flutter code | `flutter-apply-architecture-best-practices` |
| Writing or modifying widget tests | `flutter-add-widget-test` |
| Writing or modifying integration tests | `flutter-add-integration-test` |
| Adding or updating widget previews | `flutter-add-widget-preview` |
| Layouts that must adapt to different screen sizes | `flutter-build-responsive-layout` |
| Fixing layout overflows or constraint errors | `flutter-fix-layout-issues` |
| Parsing or serializing JSON into model classes | `flutter-implement-json-serialization` |
| Navigation, routing, or deep linking | `flutter-setup-declarative-routing` |
| Internationalization or localized strings | `flutter-setup-localization` |
| HTTP requests or REST API integration | `flutter-use-http-package` |

### LangChain / LangGraph

| If the task will involve… | Load upfront |
|---------------------------|--------------|
| Any LangChain agents, tools, or middleware | `langchain-fundamentals`, `langchain-dependencies` |
| Retrieval-augmented generation, embeddings, or vector stores | `langchain-rag` |
| Human approval steps or intercepting tool calls | `langchain-middleware` |
| Any LangGraph graph, nodes, edges, or state schemas | `langgraph-fundamentals` |
| Persisting graph state, conversation memory, or checkpointing | `langgraph-persistence` |
| Pausing execution for human input or approval | `langgraph-human-in-the-loop` |

## Go Directory Layout

Use package-by-feature for domains; strictly separate infrastructure adapters.

```
cmd/<appname>/        # Entry point and DI
internal/
  config/             # Environment-based config
  <feature>/          # Domain logic, entities, interfaces
  <provider>/         # Adapter implementations (e.g. postgres/, redis/, openai/)
  <transport>/        # Inbound adapters (e.g. http/, grpc/)
```

Reference: [Effective Go](https://go.dev/doc/effective_go)

## Comments and Documentation

- Write no comments unless the *why* is non-obvious.
- Document exported functions and public interfaces with concise comments using the language's standard documentation tool.
