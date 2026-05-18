# Global Agent Instructions

## Pre-Implementation Protocol

> **Skip any step already completed in this session** — do not re-read files or re-load skills already read or loaded.

1. **Read design artifacts**: Before writing any code, scan the `docs/` directory (default location) for documents relevant to the task — ADRs, requirements, design docs, and architecture diagrams. Let these artifacts shape every implementation decision. If a `docs/` directory does not exist, check for equivalent paths (`documentation/`, `design/`, `arch/`) before proceeding without them.
2. **Read the codebase** to understand the existing structure, dependencies, and patterns.
3. **Load foundational skills**: `clean-code`, `architecture-patterns`, and the language's foundational skills from the table.
4. **Identify implementation concerns** the task will require (e.g. configuration, persistence, error handling).
5. **Load skills** for each concern using the Skill Lookup Table.
6. **Enter plan mode** and plan the implementation.

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

## Implementation Principles

- **Prefer stdlib and established packages over custom implementations**: Before writing something from scratch, check whether the standard library or a well-known package already solves it. Use what exists — don't reimplement what is already battle-tested.
- **Lean toward the simplest code that works**: Among valid solutions, choose the simplest one. Complexity must justify itself.
- **Ground solutions in official documentation**: Before designing an approach, check the official docs of the language, framework, or library involved. Prefer patterns and APIs recommended by the maintainers over custom alternatives.
- **Challenge requests that conflict with or are missing from docs**: When the user asks for an implementation that contradicts documented decisions or addresses something not yet covered by them, pause and: (1) ask clarifying questions to understand the intent and context, (2) explain the implications — what existing decisions it conflicts with or what gaps it exposes, and (3) suggest whether to extend or modify the docs to capture the new information before or alongside the implementation.

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
