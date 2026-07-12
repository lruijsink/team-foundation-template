#!/usr/bin/env bash
set -euo pipefail

# format.sh <path>...: auto-format every file under the given files/dirs,
# recursively. Reports files that were changed, and files that still have
# issues the tool couldn't auto-correct.

usage() {
  echo "Usage: format.sh <path>..."
}

if [ "$#" -eq 0 ]; then
  usage
  exit 1
fi

# format_file <file>: auto-format a single file, print the file name if formatting changes were made. If auto-formatting
# fails (currently only possible for ktlint), display the error. Prettier is silenced as it cannot fail and prints all
# file names by default, even ones left unchanged.
format_file() {
  local file="$1" before after rc
  before=$(cksum < "$file")
  case "$file" in
    *.kt | *.kts) ktlint -F "$file" && rc=0 || rc=$? ;;
    *.md | *.mdx) prettier --write "$file" > /dev/null 2>&1 && rc=0 || rc=$? ;;
    *) return 0 ;;
  esac
  after=$(cksum < "$file")
  if [ "$before" != "$after" ]; then
    echo "Auto-formatted: $file"
  fi
  return "$rc"
}

files=$(find "$@" -type f)

# Exit status to-be: don't exit early, format all remaining files even if one fails
status=0

while IFS= read -r file; do # not `for file in $files`, as that splits on spaces/glob-expands special chars
  [ -z "$file" ] && continue
  if ! format_file "$file"; then
    if [ "$status" -eq 0 ]; then
      echo  # newline to separate from auto-formatted file list
      echo "Could not auto-format the following files, see errors above for what needs a manual fix:"
    fi
    echo "  $file"
    status=1
  fi
done <<< "$files" # Use here-string instead of pipe to not lose `status` updates to a subshell

exit "$status"
