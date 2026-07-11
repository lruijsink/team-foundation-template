#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

status=0

while IFS= read -r file; do
  [ -z "$file" ] && continue
  if ! ./lint.sh "$file" < "$file" > /dev/null 2>&1; then
    [ "$status" -eq 0 ] && echo "Lint failed:"
    echo "  $file"
    status=1
  fi
done <<< "$(git ls-files)"

exit "$status"
