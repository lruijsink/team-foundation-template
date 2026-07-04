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

This prompt sets up the rest of the tools and hooks automatically:

```bash
claude "Execute prompts/setup-helper.md"
```

### Brew packages

| Package                                               | Description             |
|-------------------------------------------------------|-------------------------|
| [Google Cloud SDK](https://docs.cloud.google.com/sdk) | GCP command line utils  |
| [ktlint](https://github.com/ktlint/ktlint)            | Kotlin linter           |
| [Prettier](https://prettier.io/)                      | JS, TS, Markdown linter |
| `kubectl`, `kubectx`                                  | Kubernetes CLI          |

### Auto-formatting

| Hook                                | Description                                                             |
|-------------------------------------|-------------------------------------------------------------------------|
| `pre-push` git hook                 | On push either: auto-format or reject on incorrectly formatted changes  |
| `PreToolUse` on `Write` Claude hook | Format output before displaying to user, installed via `/update-config` |
| `PostToolUse` on `Edit` Claude hook | Format entire file after modifying, installed via `/update-config`      |
