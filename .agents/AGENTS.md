# Global Agent Instructions

## Go Architecture Preferences

Hexagonal

### Directory structure

Package-by-feature for core domains, separate infrastructure packages for provider-specific adapters:

```
cmd/<appname>/          composition root and DI
internal/
  config/               env-based configuration
  <feature>/            domain-specific logic, entities and interfaces 
  infra/
    <provider>/         provider-specific implementation (e.g. keycloak/, openai/, postgres/, redis/)
```

## Relevant Skills
- `clean-architecture`
- `clean-code`
- `software-architecture`
- `golang-code-style`
- `golang-naming`
- `golang-error-handling`
- `golang-safety`
- `golang-design-patterns`
- `golang-structs-interfaces`
- `golang-modernize`
- `golang-project-layout`
- `golang-testing` 
- `golang-concurrency` 
- `golang-context`
- `golang-data-structures`
- `golang-dependency-injection`
- `golang-security`
- `golang-lint`
- `golang-documentation`

When in doubt about Go idioms, fetch https://go.dev/doc/effective_go for reference.

