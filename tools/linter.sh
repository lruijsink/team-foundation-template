#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Usage/Help
# ---------------------------------------------------------------------------

print_usage() {
  echo "Usage: $0 [-w] [-a | -s | -p | <path> [<path> ...]]"
  echo "  -w write/format files in place instead of just checking"
  echo "  -a files changed since merge-base with origin/HEAD, including uncommitted changes [DEFAULT]"
  echo "  -s files staged or modified vs HEAD"
  echo "  -p files changed since merge-base with origin/HEAD (matches pre-push scope)"
  echo "  <path>...   operate on specific files or directories directly"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  print_usage
  exit 0
fi

write="false"
if [[ "${1:-}" == "-w" ]]; then
  write="true"
  shift
fi

# Default to -a (pre-push scope plus uncommitted changes) if no arguments provided
[[ $# -eq 0 ]] && set -- "-a"

# Snapshot the file-selection args before they're consumed below, so the
# fix message can reconstruct the equivalent write-mode command.
mode_args="$*"

# ---------------------------------------------------------------------------
# File selection
# ---------------------------------------------------------------------------

# Computed unconditionally for simplicity, even though only -p and -a need them.
base_ref=$(git symbolic-ref --short refs/remotes/origin/HEAD)
merge_base=$(git merge-base HEAD "$base_ref")

if [[ "$1" == "-s" ]]; then
  files=$(git diff --name-only --diff-filter=d HEAD)
elif [[ "$1" == "-p" ]]; then
  files=$(git diff --name-only --diff-filter=d "$merge_base" HEAD)
elif [[ "$1" == "-a" ]]; then
  files=$(git diff --name-only --diff-filter=d "$merge_base")
else
  files=$(find "$@" -type f)
fi

exit_code=0

[[ "$write" == "true" ]] && echo "Auto-formatting:"

# ---------------------------------------------------------------------------
# ktlint
# ---------------------------------------------------------------------------

kt_files=$(echo "$files" | grep -E '\.(kt|kts)$' || true)

if [[ -n $kt_files ]]; then
  ktlint_flag="" # defaults to linting (check) mode
  if [[ "$write" == "true" ]]; then
    ktlint_flag="-F"
    # ktlint's json reporter stays silent about files it successfully
    # auto-fixes, so this is the only indication those files were touched.
    echo "$kt_files"
  fi

  # --log-level=error suppresses a WARN log line that would otherwise land in
  # stdout ahead of the JSON and break jq.
  kt_output=$(
    echo "$kt_files" |
    xargs ktlint --relative --reporter=json --log-level=error $ktlint_flag 2>&1
  ) || exit_code=1

  echo "$kt_output" | jq -r '.[] | .file'
fi

# ---------------------------------------------------------------------------
# prettier
# ---------------------------------------------------------------------------

md_files=$(echo "$files" | grep -E '\.(md|mdx)$' || true)

if [[ -n $md_files ]]; then
  prettier_flag="-l"
  [[ "$write" == "true" ]] && prettier_flag="-w"
  echo "$md_files" | xargs npx prettier $prettier_flag || exit_code=1
fi

# ---------------------------------------------------------------------------
# Reporting
# ---------------------------------------------------------------------------

if [[ $exit_code -ne 0 ]]; then
  echo ""
  echo "Linter encountered fatal formatting issues in the files above."
  echo "Fix with: $0 -w $mode_args"
  echo "Then amend or add a new commit and push again."
fi

exit $exit_code
