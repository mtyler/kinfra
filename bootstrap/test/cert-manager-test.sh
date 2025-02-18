#!/bin/bash
set -e

CERT_MGR_ENV="stage"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

kubectl cluster-info

## Verify Cert-Manager
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
else
  echo "\n\nCert-Manager validation passed.\n\n"
fi

# TODO delete secret
kubectl delete -f test-resources.yaml
rm test-resources.yaml
