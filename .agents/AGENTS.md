# Global Agent Instructions

## 1. Core Pre-Implementation Protocol

**This is a hard gate. Do not write any code until all steps below are complete.**

### Step 1 — Load core architectural and design pattern skills
Always load these before any implementation, no exceptions:
- `clean-code`
- `architecture-patterns`
- Standards, best practices and design patterns skills for the language in use (e.g. `python-design-patterns`, `python-code-style`, `golang-design-patterns`, `golang-code-style`, etc.)

Adhere strictly to **Clean Code** and **Clean Architecture** principles to guarantee maintainability, testability, and scalability. 
- Prioritize canonical design patterns and industry-standard best practices.
- Avoid over-engineering; select the most straightforward pattern that satisfies the architectural and business requirements.

**Technical References**
- **[Refactoring Guru: Design Patterns](https://refactoring.guru/design-patterns)**: Guide for Structural, Creational, and Behavioral pattern implementations.

### Step 2 — Find and load relevant language-specific skills
Before generating any piece of code use `find-skills` to discover and proactively load any relevant language-specific skills to ensure the implementation aligns with the best practices of the language in use.

### Step 3 — Design alignment check
Verify the proposed solution aligns with:
- `CONTEXT.md` domain language and glossary
- Any existing ADRs in the project

Only then produce the implementation.

## 2. Go Architecture Preferences: Hexagonal (Ports & Adapters)

Go applications must strictly follow the Hexagonal Architecture pattern. 

### Directory Structure
Use a **package-by-feature** approach for core domains, with strictly separated infrastructure packages for provider-specific adapters. 

```text
cmd/<appname>/          # Main entry point and dependency injection (DI)
internal/
  config/               # Environment-based configuration management
  <feature>/            # Domain logic, entities, and interfaces
  <provider>/           # Provider-specific logic and implementations of the domain interfaces (e.g., keycloak/, openai/, postgres/, redis/)
  <transport>/          # Inbound transport adapters (e.g., http/, grpc/)
```

### Technical References
- [Effective Go](https://go.dev/doc/effective_go): Canonical guide for writing idiomatic, standard-compliant Go code.

## 3. Commenting and Documentation Standards
- Avoid unecessary comments. Code should be self-explanatory through clear naming and structure.
- Use comments to exlain the "why" behind complex logic, not the "what" (which should be clear from the code itself).
- Document public interfaces and exported functions with clear, concise comments that explain their purpose, parameters, and return values. If available, use language-specific documentation tools (e.g., GoDoc for Go, Sphinx for Python) to generate API documentation from these comments.
