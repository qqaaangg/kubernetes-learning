#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="local-lab"

if k3d cluster list | grep -q "^${CLUSTER_NAME}\b"; then
  echo "[INFO] Cluster ${CLUSTER_NAME} da ton tai, bo qua tao moi."
  exit 0
fi

k3d cluster create "${CLUSTER_NAME}" \
  --servers 1 \
  --agents 2 \
  --api-port 6550 \
  -p "80:80@loadbalancer" \
  -p "443:443@loadbalancer" \
  --wait

echo "[INFO] Cluster ${CLUSTER_NAME} san sang."
kubectl cluster-info
kubectl get nodes -o wide
