#!/bin/bash
# Student Number: s3944214
# Student Name  : Kenglin Zhu
# Script        : Linux.sh
# Purpose       : Update system packages and log outputs to Linux.log

set -euo pipefail

LOG_FILE="$(cd "$(dirname "$0")" && pwd)/Linux.log"

log(){ echo "$@" | tee -a "$LOG_FILE"; }
run(){ "$@" 2>&1 | tee -a "$LOG_FILE"; }

log "===== $(date '+%Y-%m-%d %H:%M:%S') - Update start ====="

if command -v apt-get >/dev/null 2>&1; then
  run sudo apt-get update
  run sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
elif command -v dnf >/dev/null 2>&1; then
  run sudo dnf -y upgrade --refresh
elif command -v yum >/dev/null 2>&1; then
  run sudo yum -y update
else
  log "No supported package manager found (apt/dnf/yum)."
  exit 1
fi

log "===== $(date '+%Y-%m-%d %H:%M:%S') - Update end ====="
