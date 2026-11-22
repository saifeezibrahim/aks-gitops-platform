#!/usr/bin/env bash
# Installs Argo CD with Helm, then hands everything else to Git via the root app.
set -euo pipefail
cd "$(dirname "$0")/.."

helm repo add argo https://argoproj.github.io/argo-helm >/dev/null
helm repo update >/dev/null
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd --create-namespace \
  --version 7.7.5 \
  --wait

kubectl apply -f gitops/root-app.yaml

echo "Argo CD admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
echo
echo "UI: kubectl -n argocd port-forward svc/argocd-server 8081:443, then open https://localhost:8081"
