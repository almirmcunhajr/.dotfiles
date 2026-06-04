# Global Agent Instructions

## Grounding Protocol

**WHEN TO RUN**: At the start of every task — no exceptions. For pure questions or explanations with zero code output, run steps 1–5 and skip step 6.

**HARD GATE**: Do not write, edit, or suggest any implementation code until all applicable steps below are explicitly marked complete.

**SKEPTICISM**: Treat your training knowledge as unverified. Before planning or answering, confirm every approach against: (1) official documentation — use the web search tool if docs are not available locally; and (2) the loaded skills for the task. Skills and docs take precedence over training knowledge.

**Steps** (skip only if already completed earlier in this session):

1. **Scan design artifacts** — check `docs/` (fallback: `documentation/`, `design/`, `arch/`) for ADRs, requirements, and architecture diagrams relevant to the task. These shape every decision that follows.
2. **Read the codebase** — understand the existing structure, dependencies, and patterns before proposing anything new.
3. **Load foundational skills** — `clean-code`, `architecture-patterns`, `tdd`.
4. **Identify concerns** — list every concern the task touches (e.g. configuration, persistence, error handling, concurrency, testing).
5. **Load concern skills** — for each concern identified in step 4, scan the available skills list and load every relevant skill before proceeding.
6. **Enter plan mode** — produce a plan and get approval before writing code.

## General Coding Guidelines

- **No unnecessary comments.** Write only when the *why* is non-obvious.
- **Document exported interfaces.** Use concise comments on exported functions and public interfaces with the language's standard documentation tool.
- **Write documentation atomically.** Describe what something IS — not what it replaced, what was rejected, or what changed. Historical discussion belongs only in explicitly comparative sections (e.g., "Considered Options", "Alternatives") — never inline in definitions, opening statements, or action items.
- **Guard clauses.** Check preconditions and errors at the top of a function and return immediately — keep the happy path at the lowest indentation level. Invert nested `if` guards and exit early rather than nesting further.
  ```go
  // Bad
  func process(v *Foo) error {
      if v != nil {
          if v.Ready {
              return doWork(v)
          }
          return ErrNotReady
      }
      return ErrNil
  }

  // Good
  func process(v *Foo) error {
      if v == nil {
          return ErrNil
      }
      if !v.Ready {
          return ErrNotReady
      }
      return doWork(v)
  }
  ```
- **Use what already exists.** Before writing anything from scratch, verify that stdlib or an established package doesn't solve it. Do not reimplement battle-tested solutions.
- **Choose the simplest solution that works.** Complexity must justify itself — if it can't, simplify.
- **Verify every approach in official docs.** Check maintainer-recommended patterns before designing. Prefer documented APIs over custom alternatives.
- **Challenge requests that conflict with or are absent from docs.** When a request contradicts documented decisions or covers undocumented ground: (1) ask clarifying questions, (2) explain the conflict or gap, (3) suggest extending the docs before or alongside implementation.

## Go Dependency Wiring

Place the `DependencyContainer` struct and all its getter methods in `cmd/<appname>/wire.go`. Each getter is a method on `DependencyContainer` that lazily initializes and returns a single dependency.

**Getter shape — always:**
```go
type DependencyContainer struct {
    foo Foo
    bar Bar
}

func (c *DependencyContainer) Foo() Foo {
    if c.foo != nil {
        return c.foo
    }
    c.foo = newFoo(c.Bar())
    return c.foo
}
```

Rules:
- The `DependencyContainer` struct and every getter method live in `cmd/<appname>/wire.go`.
- The nil check and early return are the **first two lines** of every getter.
- One-time application startup code (server construction, listener setup, runtime config) belongs in `main.go`, not in the container. The container holds reusable dependencies; `main` owns one-time setup.
- No DI frameworks (Wire, FX, samber/do, etc.) — manual constructor injection only.

## Go Project Structure

Organize Go projects as follows. Package-by-feature for domains; strict separation of infrastructure adapters.

```
cmd/<appname>/
  main.go             # Entry point; one-time startup code
  wire.go             # DependencyContainer struct and all getters
internal/
  config/             # Environment-based config
  <feature>/          # Domain logic, entities, interfaces
  <provider>/         # Adapter implementations (e.g. postgres/, redis/, openai/)
  <transport>/        # Inbound adapters (e.g. http/, grpc/)
```

Reference: [Effective Go](https://go.dev/doc/effective_go)

