#!/usr/bin/env bash
set -euo pipefail

# lint-ci.sh: lint all tracked files in the repository using `lint.sh`. In case of linting errors, this prints which
# files did not pass the checks. This lists only the files, not why or what content didn't pass. For that refer to the
# individual tools used (currently `ktlint` and `prettier`).

# Execute from repo root
cd "$(git rev-parse --show-toplevel)"

# Includes all tracked files in the repository, not just the ones modified in this branch.
files=$(git ls-files)

# Exit status to-be: don't exit early, always lint each file to display all files that don't pass linting
status=0

while IFS= read -r file; do # not `for file in $files`, as that splits on spaces/glob-expands special chars
  [ -z "$file" ] && continue
  if ! ./lint.sh "$file" > /dev/null 2>&1; then
    [ "$status" -eq 0 ] && echo "Lint failed:"
    echo "  $file"
    status=1
  fi
done <<< "$files" # Use here-string instead of pipe to not lose `status` updates to a subshell

exit "$status"
