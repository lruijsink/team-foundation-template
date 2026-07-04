# Team Example Setup

This repository holds all shared resources for Team Example.

## Installation

### Prerequisites

Install and set up these dependencies first:

| Dependency                  | Description                |
|-----------------------------|----------------------------|
| [Homebrew](https://brew.sh) | Mac OS package manager     |
| Claude Code                 | AI agent CLI               |
| IntelliJ IDEA               | IDE                        |
| Docker + Kubernetes         | Desktop app of your choice |

### Setup helper

Run this prompt to set up the rest of the tools and dependencies automatically:

```bash
claude "Execute prompts/setup-helper.md"
```

### Brew packages

| Package                                         | Description                         |
|-------------------------------------------------|-------------------------------------|
| [gcloud-cli](https://docs.cloud.google.com/sdk) | Google Cloud SDK command line utils |
| [ktlint](https://github.com/ktlint/ktlint)      | Kotlin linter                       |
| [prettier](https://prettier.io/)                | Generic linter (used for Markdown)  |
| kubectl, kubectx                                | Kubernetes CLI                      |

### Linting

| Hook                      | Description                                    | Setting                             |
|---------------------------|------------------------------------------------|-------------------------------------|
| `pre-push` git hook       | Reject pushing changes that don't pass linting | Enforced by repository              |
| `pre-commit` git hook     | Auto-format changed files on commit (TODO)     | `git config hooks.autoFormat`       |
| `PostToolUse` Claude hook | `git add` files Claude creates                 | Enforced by `.claude/settings.json` |
| `PostToolUse` Claude hook | Auto-format files Claude creates and edits     | Enforced by `.claude/settings.json` |
