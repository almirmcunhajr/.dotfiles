# Global Agent Instructions

## 1. Core Pre-Implementation Protocol
- **Context Initialization:** Before beginning any implementation, proactively load all relevant skills (languages, frameworks, tools, and domain contexts). You must **ALWAYS** load the clean code, clean architecture, and design patterns and principles skills prior to any implementation.
- **Design Alignment:** Ensure the proposed solution aligns with the established internal logic, clean code principles, and canonical architectural patterns before generating code.

## 2. Code Design & Architecture Standards
Adhere strictly to **Clean Code** and **Clean Architecture** principles to guarantee maintainability, testability, and scalability. 

- Prioritize canonical design patterns and industry-standard best practices.
- Avoid over-engineering; select the most straightforward pattern that satisfies the architectural and business requirements.

### Technical References
- **[Refactoring Guru: Design Patterns](https://refactoring.guru/design-patterns)**: Guide for Structural, Creational, and Behavioral pattern implementations.

## 3. Go Architecture Preferences: Hexagonal (Ports & Adapters)

Go applications must strictly follow the Hexagonal Architecture pattern. 

### Directory Structure
Use a **package-by-feature** approach for core domains, with strictly separated infrastructure packages for provider-specific adapters. 

```text
cmd/<appname>/          # Main entry point and dependency injection (DI)
internal/
  config/               # Environment-based configuration management
  <feature>/            # Domain logic, entities, and interfaces
  <provider>/           # Provider-specific logic and implementations of the domain interfaces (e.g., keycloak/, openai/, postgres/, redis/)
```

### Technical References
- [Effective Go](https://go.dev/doc/effective_go): Canonical guide for writing idiomatic, standard-compliant Go code.
