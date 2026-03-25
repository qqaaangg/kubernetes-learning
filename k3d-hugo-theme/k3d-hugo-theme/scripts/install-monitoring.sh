#!/usr/bin/env bash
set -euo pipefail

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install kube-prom-stack prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f ./deploy/monitoring/kube-prometheus-stack-values.yaml \
  --wait --timeout 15m

kubectl get pods -n monitoring
kubectl get ingress -n monitoring
