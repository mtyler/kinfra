# Kinfra

basic kubernetes infrastructure bootstraping

## Dependencies

kubernetes cluster  (kubernetes cluster that responds to 'kubectl cluster-info')
kubectl             (brew install kubectl)
helm                (brew install helm)
python3             (brew install python3)
~argocd              (brew install argocd)~

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

These commands should be run from the root of this repo, from the admin workstation/same cli where kubectl is used.
1. Execute: ./bootstrap/bootstrap.sh 

2. Port-Forward: kubectl -n argocd port-forward --address 0.0.0.0 svc/argocd-server 8080:443

3. Login user:admin: kubectl -n argocd get secrets argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode

4. Create app-of-apps. 
- use path app-of-apps/apps
- exclude bootstrap

