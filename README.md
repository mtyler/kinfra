# Kinfra

basic kubernetes infrastructure bootstraping

## Dependencies

kubernetes cluster  (kubernetes cluster that responds to 'kubectl cluster-info')
kubectl             (brew install kubectl)
helm                (brew install helm)
argocd              (brew install argocd)

## Networking Dependencies

hint: curl 'https://api.ipify.org?format=json' | jq

Registered Domain (squarespace, godaddy, etc)
- DNS record= Host: @ Type: A TTL: 1h Data: [publically accessible ip address]
- DNS record= Host: @ Type: CNAME TTL: 1h Data: www.k8s.local

Router
- DNS record= Host: www.k8s.local Data: [local ip address]

### network troubleshooting tips

netcat listen on a port: nc -l 80
DNS lookup: nslookup wiredtentacle.com
MAC address: networksetup -listallhardwareports
IP address: ipconfig

## Usage

argocd admin initial-password -n argocd
