## General Coding Guidelines

- **Clean Code and Architecture**: Follow clean code and clean architecture principles. Load the `clean-code` and `architecture-patterns` skills.
- **Test-Driven Development**: Write tests first, then implement the minimal code to pass them. Load the `tdd` skill.
- **Simplicity**: Write code that minimizes cognitive load. Favor the simplest solution that satisfies current requirements over speculative generality, extra layers, or cleverness — optimize for code that's easy to read, test, and change.
- **Reuse Over Reinvention**: Reuse **industry-standard** patterns, frameworks, libraries, SDKs, and tooling over custom-built replacements. Do not reinvent capabilities that are already solved well by established ecosystem standards.
- **Defensive Flow**: Use **guard clauses** to handle errors/preconditions early. Keep the "happy path" at the minimum indentation level.
- **Skepticism**:  Treat training knowledge as unverified. Strictly follow **official documentation** and maintainer-recommended patterns and skills.
- **Comments Discipline**: Avoid redundant comments. Explain **intent** (the "Why"), not **implementation** (the "What").
- **Atomic Documentation**: Document public interfaces and exported functions using standard language tools. Write **self-contained** documentation **as-is**.
- **Doc Integrity**: Challenge requests that conflict with documented decisions. Propose updating documentation alongside implementation if gaps are found.
- **Load Relevant Skills**: Identify domains touched by the task (e.g., configuration, persistence, concurrency) and load relevant skills from the available list.

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

Reference: [Effective Go](https://go.dev/doc/effective_go)

