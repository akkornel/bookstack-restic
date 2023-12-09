#!/bin/bash
# vim: ts=4 sw=4 noet

# This script runs our backups!

set -eu
set -o pipefail

# PART 0: Check environment
# No environment needed!

# PART 1: Run check
restic check 
