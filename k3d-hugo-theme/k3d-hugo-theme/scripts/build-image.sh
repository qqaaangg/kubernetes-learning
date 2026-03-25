#!/usr/bin/env bash
set -euo pipefail

IMAGE="hugo-site:0.1.0"
CLUSTER_NAME="local-lab"

echo "[INFO] Building Docker image ${IMAGE} ..."
docker build -t "${IMAGE}" .

echo "[INFO] Importing image into k3d cluster ${CLUSTER_NAME} ..."
k3d image import "${IMAGE}" -c "${CLUSTER_NAME}"

echo "[INFO] Done."
