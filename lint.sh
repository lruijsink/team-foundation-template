#!/usr/bin/env bash
set -euo pipefail

# lint.sh <path>...: lint every file under the given files/dirs, recursively.

usage() {
  echo "Usage: lint.sh <path>..."
}

if [ "$#" -eq 0 ]; then
  usage
  exit 1
fi

# lint_file <file>: Lint a single file, silence the output but let error codes fall through.
lint_file() {
  local file="$1"
  case "$file" in
    *.kt | *.kts) ktlint "$file" ;;
    *.md | *.mdx) prettier --check "$file" ;;
    *) return 0 ;;
  esac
} > /dev/null 2>&1

files=$(find "$@" -type f)

# Exit status to-be: don't exit early, always lint each file to display all files that don't pass linting
status=0

while IFS= read -r file; do # not `for file in $files`, as that splits on spaces/glob-expands special chars
  [ -z "$file" ] && continue
  if ! lint_file "$file"; then
    [ "$status" -eq 0 ] && echo "Lint failed:"
    echo "  $file"
    status=1
  fi
done <<< "$files" # Use here-string instead of pipe to not lose `status` updates to a subshell

exit "$status"
