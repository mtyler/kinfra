#!/bin/bash
set -e

CERT_MGR_ENV="stage"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

kubectl cluster-info
for namespace in argocd bootstrap cert-manager cert-manager-test ingress-nginx; do
    if kubectl get namespace $namespace > /dev/null 2>&1; then
        read -p "Namespace '$namespace' exists. Do you want to delete it? (y/n): " confirm
        if [[ $confirm == "y" ]]; then
            kubectl delete namespace $namespace
        else
            echo "Skipping deletion of namespace '$namespace'."
            exit 1
        fi
    fi
done

## Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f ./bootstrap/argocd/install.yaml

#kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
#kubectl port-forward svc/argocd-server -n argocd 8080:443

