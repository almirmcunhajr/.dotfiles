## General Guidelines

- **Clean Code and Architecture**: Follow clean code and clean architecture principles. Load the `clean-code` and `architecture-patterns` skills before writing any code.
    - **Single Responsibility**: Each function, method, and class should have one cohesive purpose and one reason to change. Extract independently changing responsibilities into clearly named functions. "Functions should do one thing. They should do it well. They should do it only." - Robert C. Martin
- **Test-Driven Development**: Write tests first, then implement the minimal code to pass them. Load the `tdd` skill before any implementation.
- **Simplicity**: Write code that minimizes cognitive load. Favor the simplest solution that satisfies current requirements over speculative generality, extra layers, or cleverness — optimize for code that's easy to read, test, and change.
- **Reuse Over Reinvention**: Reuse **industry-standard** patterns, frameworks, libraries, SDKs, and tooling over custom-built replacements. Do not reinvent capabilities that are already solved well by established ecosystem standards.
- **Proven Over Assumed**: Default to approaches, patterns, and mechanisms with a **demonstrated track record** — grounded in **official documentation**, **established ecosystem practice**, **industry-standard**, **well-maintained** frameworks/libraries/SDKs/tooling, or **well-established theoretical patterns and concepts from the literature** — over **untested assumptions or novel constructions**. If no proven precedent exists, **say so explicitly and validate the new approach** (via docs, tests, or a spike) before committing to it.
- **Defensive Flow**: Use **guard clauses** to handle errors/preconditions early. Keep the "happy path" at the minimum indentation level.
- **Skepticism**:  Treat training knowledge as unverified. Strictly follow **official documentation** and maintainer-recommended patterns and skills.
- **Comments Discipline**: Avoid redundant comments. Explain **intent** (the "Why"), not **implementation** (the "What").
- **Atomic Documentation**: Document public interfaces and exported functions using standard language tools. Write **self-contained** documentation **as-is**. Don't append what it *isn't*, what it *used to be*, or what a prior/alternative design would have done.
- **Doc Integrity**: Challenge requests that conflict with documented decisions. Propose updating documentation alongside implementation if gaps are found.
- **Load Relevant Skills**: Identify domains touched by the task (e.g., configuration, persistence, concurrency) and load relevant skills from the available list.

## Live Infrastructure Safety

- **Never run live infrastructure CLI commands.** The agent is not allowed to execute CLI commands that can inspect, change, deploy to, or delete resources in live infrastructure.
- This prohibition explicitly includes `kubectl`, AWS CLI commands such as `aws`, and equivalent commands for any cloud or production system.
- Use MCP, local files, static configuration inspection, mocks, dry-run tooling that cannot contact live infrastructure, or documentation instead. If a live-infrastructure action is needed, stop and ask the user to perform it.

## Go Dependency Wiring

Place the `DependencyContainer` struct and all its getter methods in `cmd/<appname>/wire.go`. Use lazy initialization.

**Standard Getter Pattern**:
```go
func (c *DependencyContainer) Foo() (Foo, error) {
    if c.foo != nil {
        return c.foo, nil
    }
    foo, err := newFoo(c.Bar())
    if err != nil {
        return nil, err
    }
    c.foo = foo
    return c.foo, nil
}
```

- **Location**: `cmd/<appname>/wire.go` for the container and all getters.
- **Structure**: Nil check and early return MUST be the first lines.
- **Ownership**: `main.go` owns one-time startup (listeners, runtime config). `wire.go` owns reusable dependencies.
- **No Frameworks**: Use manual constructor injection only.

## Go Code Review

When reviewing Go code, apply the guidance in the [Go Code Review Comments wiki](https://go.dev/wiki/CodeReviewComments) as the canonical source for style and idiom feedback.

## Go Project Structure

Follow the **Package-by-Feature** pattern with strict adapter separation.

```
cmd/<appname>/
  main.go             # App entry; one-time startup
  wire.go             # DependencyContainer and lazy getters
internal/
  config/             # Environment-based configuration
  <feature>/          # Domain logic, entities, interfaces
  <provider>/         # Outbound adapters (postgres, redis, etc.)
  <transport>/        # Inbound adapters (http, grpc, etc.)
```

## Go Idiomatic Style

When writing Go code, apply the guidance in [Effective Go](https://go.dev/doc/effective_go) as the canonical source for writing clear, idiomatic Go.

## Python Project Structure

Follow PyPA's documented **src layout** and the **Package-by-Feature** pattern with strict adapter separation.

```text
pyproject.toml
src/
  <package_name>/
    __init__.py
    config/             # Environment-based configuration
    logging/            # Application logging
    <feature>/          # Feature logic and shared contracts
    <provider>/         # Outbound integrations (postgres, redis, bedrock, etc.)
    <transport>/        # Inbound transport integrations
    entrypoints/        # Process startup, dependency wiring, request handlers
tests/                  # Tests outside the import package
```

- **Import Package**: Use one application-specific top-level import package under `src/`, named in `snake_case`. Feature, provider, and transport directories are subpackages of that package.
- **Packaging Reference**: Use [PyPA's src layout guidance](https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/) for source placement. The internal package organization above is our project convention.
- **Package Boundaries**: Group feature logic and contracts by feature. Keep external framework, provider, and transport integrations in separate, explicitly named packages.
- **Dependency Direction**: Integration packages may depend on feature contracts. Feature packages must remain independent of integrations and entrypoints.
- **Consumer-Owned Interfaces**: Define `Protocol` interfaces alongside their consumers, including in an entrypoint when that is the consumer.
- **Module Names**: Use descriptive `snake_case` names such as `invocation.py`, `support_agent.py`, and `browser_tools.py`. Name middleware modules with the `_middleware.py` suffix.
- **Imports**: Use absolute imports rooted at `<package_name>`.
- **Package Initialization**: Include `__init__.py` in regular packages. Keep directory nesting shallow and add packages only for cohesive responsibilities.

## Python Dependency Wiring

- **Composition Root**: Entrypoints own configuration loading, concrete dependency construction, and application startup.
- **Constructor Injection**: Pass ready-to-use dependencies into feature and integration objects through their constructors.
- **Tool Catalogs**: Discover tools and assemble the complete catalog at startup, then inject the concrete tool sequence into the agent. Tool-selection policy belongs in middleware.
- **Resource Lifetimes**: Manage asynchronous resources with context managers. Use `AsyncExitStack` to compose resource-owning integrations and guarantee cleanup.
- **Application Services**: Introduce a separate service or handler when it owns meaningful application orchestration. Keep payload parsing, runtime-context validation, and response serialization at the entrypoint boundary.
