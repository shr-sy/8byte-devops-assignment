#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
python -m pip install -r app/requirements.txt >/dev/null
python -m pytest app/tests -q
