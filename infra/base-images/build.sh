#!/bin/bash

set -e

REGISTRY="${REGISTRY:-}"
VERSION="${VERSION:-20-alpine3.19}"
BACKEND_IMAGE="${REGISTRY}backend-base:${VERSION}"
FRONTEND_IMAGE="${REGISTRY}frontend-build-base:${VERSION}"

echo "Building base images..."

echo "Building backend base image..."
docker build -t "${BACKEND_IMAGE}" ./backend-base/

echo "Building frontend build base image..."
docker build -t "${FRONTEND_IMAGE}" ./frontend-build-base/

echo "Scanning backend base image for vulnerabilities..."
docker scan "${BACKEND_IMAGE}" || echo "Scan failed or not available"

echo "Scanning frontend build base image for vulnerabilities..."
docker scan "${FRONTEND_IMAGE}" || echo "Scan failed or not available"

echo "Build complete!"
echo "Backend image: ${BACKEND_IMAGE}"
echo "Frontend image: ${FRONTEND_IMAGE}"

