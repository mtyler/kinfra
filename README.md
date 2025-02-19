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

3. ArgoCD Login user:admin: kubectl -n argocd get secrets argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode

4. Create app-of-apps. 
- use path app-of-apps/apps
- exclude bootstrap

### tasks
#### is cert-manager still failing liveness probe?

#### kublet client certificate failing.
err="part of the existing bootstrap client certificate in /etc/kubernetes/kubelet.conf is expired: 2026-02-18 22:10:15 +0000 UTC" 
err="failed to run Kubelet: unable to load bootstrap kubeconfig: stat /etc/kubernetes/bootstrap-kubelet.conf: no such file or directory"
Flag --container-runtime-endpoint has been deprecated, This parameter should be set via the config file specified by the Kubelet's --c>
Apr 11 21:01:46 lima-n3 kubelet[89874]: Flag --pod-infra-container-image has been deprecated, will be removed in 1.35.

mtyler@lima-n3:~$ sudo cat /etc/kubernetes/kubelet.conf
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJVFk4T3F4bnBqa293RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TlRBeU1UZ3lNakExTWpWYUZ3MHpOVEF5TVRZeU1qRXdNalZhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUUM4RjFTRVBWaXcvTGExVDB2S2FDdDNibFFQOEcybzN1bVFLYUcvYzhtMkpTRCtyZmtzSkxHaEN3Y0IKZDFJY2ZoejF4SUNlYmdPMXNQNkIrdjZyV3dtbVprUEJZcXZ1MEs0T0o4Y3RoTVJSQ1RtVHQyYm10S3FYVmVxdgpMVG5WbzFhaSt0OFhsL3J5MnpUL2xmUFRnMElnalpTdVNSSVhEdDFlUFJZNVZSMm1RYWVLRUxJbUppT1ZHK1V3CmFWS2c1U0tIb0pSekN5OUEvVXBQNjhxTUp4aVZHMVBPaWFCYmlDWXFObzFvSlMrWFZjSnVkdndMV3dMUWJzSEEKMGh3cTFrYUNSS1BtMU5nVzNUUXlnNHFIK3l3Z1pIcXBHNnhVaXpKSTNhaGV2MzdYR2VoL3NiWWtzblhuU3I4ZQpHYnZtWndIdnY1Q1RwUm9kQ0QwRnhuRjZMRW5kQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJRK0RPSEZ2WjZUWkFGT1psbk9jZVN2WDFpYmhqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQlVkZDh0NzhLLwpiMXIwVXhVVGhSTGRIQ3lQaFdEaDc4eHAwbHNLTFJsL3N0K3pFakJ5amdXQnRhb0x2TmVmdjFtakVRRHd0RU05ClU0YU9TUDlmelpVQnYrYVkrcTc5Q1c0a2N6R3F3LzdlcXJFaWYzV1JKbXJEQXhHUVA4cFRNWHVESGlkRE5lWVUKeHUvalZKTDRnTkpyNFd4U29zL09OM2M1MDBoOWNaZXVjaGVhMDF3a0ZmYm5LMjdWd29iV1UyUWx2M3Q1SUt1MQprY2tIbWNsTVp3K3dIRlBBNS95RERSK0ZjdVNTeis4eHlmbjVqbUFxclVmdjAyd0VGSElaTEZYS3pFa3RIT29LCkd2QW5CbjBQay9YQzF4ank2eHdrQU5lT2ZTcnVYTTNDK2d1Nzk4V05SR3lzc05UUy8wWnBrVDh2MlU2THNRVnUKQktWNTlyU3Qrb21zCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    server: https://192.168.105.7:6443
  name: default-cluster
contexts:
- context:
    cluster: default-cluster
    namespace: default
    user: default-auth
  name: default-context
current-context: default-context
kind: Config
preferences: {}
users:
- name: default-auth
  user:
    client-certificate: /var/lib/kubelet/pki/kubelet-client-current.pem
    client-key: /var/lib/kubelet/pki/kubelet-client-current.pem


mtyler@lima-n3:~$ sudo ls -la /var/lib/kubelet/pki/
total 20
drwxr-xr-x 2 root root 4096 Feb 18  2025 .
drwxrwxr-x 9 root root 4096 Feb 18  2025 ..
-rw------- 1 root root 1110 Feb 18  2025 kubelet-client-2025-02-18-17-15-15.pem
lrwxrwxrwx 1 root root   59 Feb 18  2025 kubelet-client-current.pem -> /var/lib/kubelet/pki/kubelet-client-2025-02-18-17-15-15.pem
-rw-r--r-- 1 root root 2262 Feb 18  2025 kubelet.crt
-rw------- 1 root root 1675 Feb 18  2025 kubelet.key

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/#kubelet-client-cert

#### Node Exporter not exporting nodes
- curl the endpoint: curl 10.101.88.172:9100/metrics
success
- why is prometheus not getting data to grafana

- prometheus shows node exporter and state metrics offline
  "no active targets in this scrape pool"
  where is scrape pool defined?

  There is a selector-label mismatch between serviceMonitor and node-exporter service