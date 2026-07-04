# Team Example Setup

This repository holds all shared resources for Team Example.

## Installation

### Prerequisites

Install and set up these dependencies first:

| Dependency                  | Description                |
| --------------------------- | -------------------------- |
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
| ----------------------------------------------- | ----------------------------------- |
| [gcloud-cli](https://docs.cloud.google.com/sdk) | Google Cloud SDK command line utils |
| [ktlint](https://github.com/ktlint/ktlint)      | Kotlin linter                       |
| [prettier](https://prettier.io/)                | Generic linter (used for Markdown)  |
| kubectl, kubectx                                | Kubernetes CLI                      |

### Linters

TODO: Explain `tools/linter.sh`

| Linter     | File types   | Enforced              | Settings      | Compatibility      |
| ---------- | ------------ | --------------------- | ------------- | ------------------ |
| `ktlint`   | `.kt` `.kts` | Yes, required to push | .editorconfig | CLI, IntelliJ IDEA |
| `prettier` | `.md` `.mdx` | No                    | .prettierrc   | CLI [1]            |

[1]: Compatible but only works in projects with NPM, not Maven

### git hooks

Defined in `.githooks`, applied by default by git

| Hook         | Description                                                                                                  |
| ------------ | ------------------------------------------------------------------------------------------------------------ |
| `pre-push`   | Reject push on linting failure, vs. `origin/HEAD`                                                            |
| `pre-commit` | Reject commit on linting failure, vs. staged changes. On by default, disable with `hooks.lintOnCommit false` |

### Claude hooks

Defined in `.claude/settings.json`, applied by default by Claude

| Hook                         | Description                                                                                |
| ---------------------------- | ------------------------------------------------------------------------------------------ |
| `PostToolUse`, `Write`       | `git add` files Claude creates                                                             |
| `PostToolUse`, `Write\|Edit` | Auto-format files Claude edits. Off by default, enable with `hooks.claude.autoFormat true` |

## TODO: Repository bootstrapping
