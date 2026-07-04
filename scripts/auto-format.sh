#!/usr/bin/env bash

files=$(git diff --name-only HEAD; git diff --cached --name-only HEAD)

kt_files=$(echo "$files" | grep -E '\.(kt|kts)$')
if [[ -n $kt_files ]]; then
  echo "$kt_files" | xargs ktlint -F
fi

md_files=$(echo "$files" | grep -E '\.(md|mdx)$')
if [[ -n $md_files ]]; then
  echo "$md_files" | xargs prettier -w
fi
