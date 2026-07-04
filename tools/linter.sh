#!/usr/bin/env bash
set -euo pipefail

print_usage() {
  echo "Usage: $0 [-w] -s | -p | <path> [<path> ...]"
  echo "  -w write/format files in place instead of just checking"
  echo "  -s files staged or modified vs HEAD"
  echo "  -p files changed since merge-base with origin/HEAD (matches pre-push scope)"
  echo "  <path>...   operate on specific files or directories directly"
}

usage() {
  print_usage >&2
  exit 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  print_usage
  exit 0
fi

ktlint_flag=""
prettier_flag="-c"
if [[ "${1:-}" == "-w" ]]; then
  ktlint_flag="-F"
  prettier_flag="-w"
  shift
fi

[[ $# -eq 0 ]] && usage

# Snapshot the file-selection args before they're consumed below, so the
# fix message can reconstruct the equivalent write-mode command.
mode_args="$*"

if [[ "$1" == "-s" ]]; then
  files=$(git diff --name-only --diff-filter=d HEAD)
elif [[ "$1" == "-p" ]]; then
  base_ref=$(git symbolic-ref --short refs/remotes/origin/HEAD)
  merge_base=$(git merge-base HEAD "$base_ref")
  files=$(git diff --name-only --diff-filter=d "$merge_base" HEAD)
else
  files=$(find "$@" -type f)
fi

exit_code=0

kt_files=$(echo "$files" | grep -E '\.(kt|kts)$' || true)
md_files=$(echo "$files" | grep -E '\.(md|mdx)$' || true)

if [[ "$ktlint_flag" == "-F" && ( -n $kt_files || -n $md_files ) ]]; then
  echo "Auto-formatting:"
fi

if [[ -n $kt_files ]]; then
  [[ "$ktlint_flag" == "-F" ]] && echo "$kt_files"
  echo "$kt_files" | xargs ktlint $ktlint_flag || exit_code=1
fi

# Prettier is advisory only (conflicts with the IntelliJ formatter), so it
# never fails the script, regardless of check/write mode.
if [[ -n $md_files ]]; then
  echo "$md_files" | xargs prettier $prettier_flag || true
fi

if [[ $exit_code -ne 0 ]]; then
  echo ""
  echo "Linter encountered fatal formatting issues in the files above."
  echo "Fix with: $0 -w $mode_args"
  echo "Then amend or add a new commit and push again."
fi

exit $exit_code
