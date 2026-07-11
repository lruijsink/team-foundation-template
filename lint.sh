#!/usr/bin/env bash
set -euo pipefail

# lint.sh <path>: lint content provided via stdin. <path> is used to determine
# the correct linter and config files to apply.
path="$1"
case "$path" in
  *.kt | *.kts) ktlint --stdin --stdin-path="$path" ;;
  *.md | *.mdx) prettier --stdin-filepath "$path" --check ;;
  # Drain stdin so the writer on the other end doesn't get SIGPIPE'd.
  *) cat > /dev/null ;;
esac
