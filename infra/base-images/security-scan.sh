#!/bin/bash

set -e

REGISTRY="${REGISTRY:-}"
VERSION="${VERSION:-20-alpine3.19}"
BACKEND_IMAGE="${REGISTRY}backend-base:${VERSION}"
FRONTEND_IMAGE="${REGISTRY}frontend-build-base:${VERSION}"

echo "Scanning base images for vulnerabilities..."

if command -v docker &> /dev/null && docker info &> /dev/null; then
    echo "Scanning backend base image..."
    docker scan "${BACKEND_IMAGE}" --accept-license --json > backend-scan.json 2>&1 || true
    
    echo "Scanning frontend build base image..."
    docker scan "${FRONTEND_IMAGE}" --accept-license --json > frontend-scan.json 2>&1 || true
    
    echo "Scan complete. Results saved to backend-scan.json and frontend-scan.json"
else
    echo "Docker scan not available. Install Docker Desktop or use Snyk/Trivy for scanning."
fi

