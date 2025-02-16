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

## Install Cert-Manager
helm repo add jetstack https://charts.jetstack.io --force-update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.17.0 \
  --set crds.enabled=true

# Test Cert-Manager
cat <<EOF > test-resources.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: cert-manager-test
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: test-selfsigned
  namespace: cert-manager-test
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: selfsigned-cert
  namespace: cert-manager-test
spec:
  dnsNames:
    - example.com
  secretName: selfsigned-cert-tls
  issuerRef:
    name: test-selfsigned
EOF
kubectl apply -f test-resources.yaml
sleep 5
rc=$(kubectl describe certificate -n cert-manager-test | grep -A 7 'Status:' | grep -A 6 'Conditions:' | grep 'True')
echo $rc
if [[ $rc != *"True"* ]]; then
  echo "Cert-Manager is not working"
  exit 1
fi
# todo delete secret
kubectl delete -f test-resources.yaml
rm test-resources.yaml

## Install Ingress-Nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx --force-update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer \
  --

kubectl get all -n ingress-nginx

if [[ $CERT_MGR_ENV == "stage" ]]; then
    kubectl apply -f $SCRIPT_DIR/stageClusterIssuer.yaml
fi

kubectl apply -f $SCRIPT_DIR/bootstrap.yaml
##one of three ways to access argocd
##kubectl apply -f $SCRIPT_DIR/argocdIngress.yaml
