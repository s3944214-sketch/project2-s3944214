#!/bin/bash
# Student Number: s3944214
# Student Name  : Kenglin Zhu
# Script        : searchdata.sh

set -euo pipefail
read -p "Enter filename: " file
if [[ -f "$file" ]]; then
  read -p "Enter text to search: " needle
  grep -i -- "$needle" "$file" > pattern.txt || true
  echo "Matches (if any) saved to pattern.txt"
else
  echo "File not found"
  exit 1
fi
