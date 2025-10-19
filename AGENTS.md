# Repository Guidelines

## Project Structure & Module Organization
This repository evaluates automated container image update tooling. Key files:
- `README.md` tracks research goals, scenarios, and open questions. Update the checklists rather than duplicating context elsewhere.
- `.github/workflows/` will hold GitHub Actions for Dependabot, Renovate, and Digestabot experiments; group workflows by tool (`dependabot-update.yml`, `renovate-digests.yml`) and keep shared steps in reusable actions when possible.
- Future helper scripts should live under `scripts/` with the executable bit set and a short `--help` usage message.

## Build, Test, and Development Commands
- `actionlint .github/workflows/*.yml` validates workflow syntax before pushing. Install via `brew install actionlint` or `go install github.com/rhysd/actionlint/cmd/actionlint@latest`.
- `act --job <job>` offers a local dry run of workflow jobs. Use it for quick sanity checks when editing multiple matrices.
- `gh workflow run <workflow>` can trigger remote runs when you need to observe GitHub's environment-specific behavior.

## Coding Style & Naming Conventions
- Use two-space indentation for YAML and keep job/step ids lowercase with hyphens (`pin-digest`, `update-summary`).
- Declare explicit `permissions` in every workflow; start from read-only (`contents: read`) and elevate only what a job requires (e.g., add `pull-requests: write` before automations that open PRs).
- Prefer descriptive workflow names that surface the tool and scope (`Dependabot Digest Watch`, `Renovate Registry Sweep`).
- Shell snippets in workflows should be POSIX-compatible and start with `set -euo pipefail` to catch silent failures.

## Testing Guidelines
- Treat each workflow change like code: capture expected behavior in comments or the README checklist and, when possible, add automated assertions (e.g., `if` guards that fail on missing digests).
- Document test artifacts: if a workflow requires fixtures (sample Dockerfiles, Compose files), place them under `fixtures/` and annotate their purpose in the README.
- After introducing new registries or tags, confirm the scenario by running the relevant workflow in a feature branch and attaching the run link to the PR.

## Commit & Pull Request Guidelines
- Use imperative, scope-prefixed commit subjects (`docs: outline renovate workflow plan`). Keep the first line ≤72 characters and expand context in the body when needed.
- Pull requests should summarize the scenario under test, list key workflow files touched, link any related issue or run, and include screenshots of generated PRs when comparing tooling behavior.

## Security & Configuration Tips
- Never commit real credentials or tokens; rely on repository or organization secrets and document any new secret name in the PR description.
- When referencing external registries, prefer official image digests and cite the source in comments to aid future audits.
