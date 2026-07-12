#!/usr/bin/env bash
set -euo pipefail

path="$1"
case "$path" in
  *.kt | *.kts) ktlint "$path" ;;
  *.md | *.mdx) prettier --check "$path" ;;
  *) exit 0 ;;
esac
