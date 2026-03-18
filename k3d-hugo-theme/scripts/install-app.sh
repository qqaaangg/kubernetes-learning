#!/usr/bin/env bash
set -euo pipefail

kubectl create namespace web --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install hugo-site ./chart/hugo-site -n web -f ./chart/hugo-site/values-local.yaml

kubectl rollout status deploy/hugo-site -n web --timeout=180s
kubectl get all -n web
kubectl get ingress -n web
