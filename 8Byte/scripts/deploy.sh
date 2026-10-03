#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Building Docker image..."
docker build -t 8byte-app ./app

echo "Starting application container..."
docker run --rm -d -p 8000:8000 --name 8byte-app 8byte-app

echo "Application is running on http://localhost:8000"
