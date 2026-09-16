# >>> agentbox managed rules >>>
# Global rules managed by agentbox setup.

## Commit Safety
- Never commit directly on `main`; create a feature branch first.
- Keep commits focused and atomic.
- Use imperative commit subjects (Add, Fix, Update, Refactor, Remove).
- Keep commit messages concise and specific.

## Pull Request Workflow
- Create or update `.agentbox-pr.md` at repository root before opening a PR.
- `.agentbox-pr.md` format:
  - `Title: <short title>`
  - `Base: <target branch>`
  - `Draft: true|false`
  - blank line, then markdown body
- Ensure `.agentbox-pr.md` is ignored by Git if missing:
  - prefer adding `.agentbox-pr.md` to repository `.gitignore`
  - if repository policies block this, use `.git/info/exclude`
- Use `agentbox pr` to re-sign outgoing commits, push branch, and create/update the GitHub PR.

## Alignment
- If a repository has its own `AGENTS.md`, follow it as the source of project-specific instructions.
- Use agentbox repository commit style as baseline when no local style is defined.
# <<< agentbox managed rules <<<
