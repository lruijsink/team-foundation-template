#!/usr/bin/env bash
set -euo pipefail

base_ref=$(git symbolic-ref --short refs/remotes/origin/HEAD)
merge_base=$(git merge-base HEAD "$base_ref")

files=$(git diff --name-only "$merge_base" HEAD)

echo "$files" | grep -E '\.(kt|kts)$' || true | xargs -r ktlint "src/**/*.kt" -F
echo "$files" | grep -E '\.(ts|tsx|js|jsx|md)$' || true | xargs -r prettier -w
