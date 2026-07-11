# Team Example Setup

This repository holds all shared resources for Team Example.

## Installation

### Prerequisites

Install and set up these dependencies first:

| Dependency                                                         | Description                |
|--------------------------------------------------------------------|----------------------------|
| [Homebrew](https://brew.sh)                                        | Mac OS package manager     |
| [Node.js](https://nodejs.org)                                      | For NPM                    |
| Docker + Kubernetes                                                | Desktop app of your choice |
| IntelliJ IDEA                                                      | IDE                        |
| [ktlint plugin](https://plugins.jetbrains.com/plugin/15057-ktlint) | IntelliJ ktlint support    |
| Claude Code                                                        | AI agent CLI               |

### Packages

| Package                                    | Installed via | Description     |
|--------------------------------------------|---------------|-----------------|
| [ktlint](https://github.com/ktlint/ktlint) | Homebrew      | Kotlin linter   |
| [Prettier](https://prettier.io)            | NPM           | Markdown linter |

Install via:

```bash
brew install ktlint
npm install -g prettier
```

### Configure IntelliJ

IntelliJ requires ktlint and Prettier settings to be set per-project, there is no overridable global IDE default. The
default settings do not apply Prettier formatting, even if a `.prettierrc` file is present. Format on save can also not
be set globally, and is disabled by default, though it is recommended to enable. To enable automatic formatting
consistent with the linters, copy the following files into every project's `.idea` folder:

- `.idea/prettier.xml`
- `.idea/ktlint-plugin.xml`

Or apply these settings manually as follows:

- **ktlint**
    - Go to `IntelliJ IDEA` → `Settings...` → `Tools` → `KtLint`
        - Enable `Distract free mode`
        - Enable `✅ on save`

- **Prettier** (comes bundled with IDEA)
    - Go to `IntelliJ IDEA` → `Settings...` → `Languages & Frameworks` → `JavaScript` → `Prettier`
        - Select `🔘 Automatic Prettier configuration`
        - Append `md` and `mdx` to the `Run for files:` glob file type list
        - Enable `✅ Run on save`
        - Enable `✅ Run on paste`
        - Enable `✅ Prefer Prettier configuration to IDE code style`

Even with Prettier enabled IntelliJ still displays conflicting inspections. Disable these via Context Actions when they
appear, or directly in the settings:

- Go to `IntelliJ IDEA` → `Settings...` → `Editor` → `Inspections`
    - Disable `Markdown table formatting`
    - Disable other inspections if they conflict with Prettier
    - Select `Profile:` → `Stored in IDE` → `Default` to apply this to ALL projects by default

### git hooks

| Hook         | Description                                                                                                  |
|--------------|--------------------------------------------------------------------------------------------------------------|
| `pre-push`   | Reject push on linting failure, vs. `origin/HEAD`                                                            |
| `pre-commit` | Reject commit on linting failure, vs. staged changes. On by default, disable with `hooks.lintOnCommit false` |

### Claude hooks

Defined in `.claude/settings.json`, applied by default by Claude

| Hook                         | Description                                                                                |
|------------------------------|--------------------------------------------------------------------------------------------|
| `PostToolUse`, `Write\|Edit` | Auto-format files Claude edits. Off by default, enable with `hooks.claude.autoFormat true` |
