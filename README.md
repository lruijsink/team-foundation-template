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
| kubectl, kubectx                                | Kubernetes CLI                      |

Also run `npm install -g prettier` once, this installs `prettier` globally so both the CLI (`tools/linter.sh`, via
`npx`) and the IntelliJ Prettier plugin resolve the same version.

### Linters

TODO: Explain `tools/linter.sh`

| Linter     | File types   | Enforced              | Settings      |
| ---------- | ------------ | --------------------- | ------------- |
| `ktlint`   | `.kt` `.kts` | Yes, required to push | .editorconfig |
| `prettier` | `.md` `.mdx` | Yes, required to push | .prettierrc   |

### IntelliJ IDEA: Auto-formatting settings

To auto-apply the linting rules correctly in IntelliJ IDEA, configure the following:

- **ktlint**
  - Install [ktlint plugin](https://plugins.jetbrains.com/plugin/15057-ktlint)
  - Go to IDEA → Settings... → Tools → KtLint
    - Enable "Distract free" mode
    - Enable "✅ on save"
- **Prettier** (comes bundled with IDEA)
  - Run `npm install -g prettier`
  - Go to IDEA → Settings... → Languages & Frameworks → JavaScript → Prettier
    - Select "Automatic Prettier configuration" (uses the globally installed package)
    - Add `md` and `mdx` to the "Run for files:" glob
    - Enable "✅ Run on save"
    - Enable "✅ Run on paste"
    - Enable "✅ Prefer Prettier configuration to IDE code style"
  - Go to IntelliJ IDEA → Settings... → Editor → Inspections
    - Disable "Markdown table formatting"
    - Disable other inspections if they conflict with Prettier (they don't consider `.prettierrc`)

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
| `PostToolUse`, `Write\|Edit` | Auto-format files Claude edits. Off by default, enable with `hooks.claude.autoFormat true` |

## TODO: Repository bootstrapping
