#!/usr/bin/env bash

# Run the Python orchestration script for integration tests
# IMPORTANT: Do not change the timeout!
set -eu -o pipefail
cabal build
cabal test
NEWPYTHONPATH="$(pwd)/integration_tests:${PYTHONPATH:-}"
export PYTHONPATH="${NEWPYTHONPATH}"
exec timeout 120s python3 integration_tests/orchestrate_integration_tests.py "$@"
