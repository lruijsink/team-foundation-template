# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

A team foundation/starter repo: shared linting setup, IDE config, and git hooks meant to be reused across the team's
actual project repos. There is no application code here — just tooling.

## Linting commands

- `tools/lint.sh <path>...` - lint one or more files/dirs, recursively (check only, no fixes). Files/dirs are required
  args; running with none prints usage and exits 1.
- `tools/format.sh <path>...` - auto-format one or more files/dirs, recursively. Fixes what it can, reports what it
  can't (e.g. ktlint can't auto-fix wildcard imports).
- `tools/lint-ci.sh` - lints every tracked file in the repo (`git ls-files`). This is the source of truth for whether
  the repo is clean; run this to reproduce what CI checks.

`lint.sh`/`format.sh` dispatch by extension: `.kt`/`.kts` → ktlint, `.md`/`.mdx` → Prettier. Any other extension is a
silent no-op — this is the single place that mapping lives, so adding a new language means editing the `case` statement
in both scripts, nowhere else.

To lint/format a single file while iterating: `tools/lint.sh path/to/File.kt` or `tools/format.sh path/to/File.kt`.

## Git hooks

`core.hooksPath` is set to `git-hooks/` (not the default `.git/hooks/`), so hooks are versioned in this repo.

- `git-hooks/pre-commit` - lints staged files, blocks the commit on failure. Because a file can be partially staged, it
  never lints the working-tree copy directly — it extracts the staged blob via `git show ":$file"` into a temp file
  under `.lint-tmp/` at the repo root (cleaned up via `trap` on exit) and lints that. `.lint-tmp` is deliberately at the
  repo root rather than `/tmp` or under `.git/`: linters need to resolve `.editorconfig`/ `.prettierrc` via upward
  directory search, and Prettier hardcodes `.git` as an ignored path (any file under `.git/` is silently skipped). It
  resolves `tools/lint.sh`/`tools/format.sh` relative to its own location (not the caller's cwd), since `core.hooksPath`
  can point at a hooks directory outside the repo being committed to.
- Auto-formatting on commit is opt-in per clone, off by default: `git config hooks.auto-format true`. When on, it only
  auto-formats and re-stages files that are _fully_ staged (`git diff --quiet -- "$file"`), so it never silently stages
  unstaged edits.

## Claude Code auto-format hook

A `PostToolUse` hook (`.claude/settings.json`, matcher `Edit|Write`) runs `tools/format.sh` on any file Claude edits or
writes. Also opt-in, off by default, via its own separate flag: `git config hooks.claude-auto-format true`.

Because of this hook, **don't spend effort manually formatting `.kt`/`.kts`/`.md`/`.mdx` files** — when the flag is
enabled, formatting is handled automatically after every edit. Focus on content and correctness.

## Config files

- `.editorconfig` - ktlint settings (e.g. disables wildcard imports)
- `.prettierrc` - Prettier settings (`printWidth: 120`, `proseWrap: always`)

## IDE setup

IntelliJ requires ktlint/Prettier settings to be configured per-project (no global override, and format-on-save is off
by default). See the README's "Configure IntelliJ" section for the manual steps, or copy `.idea/prettier.xml` and
`.idea/ktlint-plugin.xml` into a project's `.idea` folder.
