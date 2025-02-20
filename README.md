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


### tasks
#### is cert-manager still failing liveness probe?

#### kublet client certificate rotation failing.
err="part of the existing bootstrap client certificate in /etc/kubernetes/kubelet.conf is expired: 2026-02-18 22:10:15 +0000 UTC" 
err="failed to run Kubelet: unable to load bootstrap kubeconfig: stat /etc/kubernetes/bootstrap-kubelet.conf: no such file or directory"
Flag --container-runtime-endpoint has been deprecated, This parameter should be set via the config file specified by the Kubelet's --c>
Apr 11 21:01:46 lima-n3 kubelet[89874]: Flag --pod-infra-container-image has been deprecated, will be removed in 1.35.

mtyler@lima-n3:~$ sudo cat /etc/kubernetes/kubelet.conf

mtyler@lima-n3:~$ sudo ls -la /var/lib/kubelet/pki/

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/#kubelet-client-cert

kubectl get csr -n kube-system
openssl x509 -in /var/lib/kubelet/pki/kubelet-client-current.pem -noout -dates
/etc/kubernetes/kubelet < does --rotate-server-certificates flag is set to true

rotateCertificates: true

rotateCertificates enables client certificate rotation. The Kubelet will request a new certificate from the certificates.k8s.io API. This requires an approver to approve the certificate signing requests. Default: false

****Added self-signed CA to cluster

System clock is out of synch
Feb 19 18:16:28 lima-n3 chronyd[2504]: Forward time jump detected!

Apr 12 16:28:50 lima-n3 chronyd[39331]: Could not step system clock
Apr 12 16:29:54 lima-n3 chronyd[39331]: System clock wrong by -3002385021.274820 seconds

!! recovered node by draining and restarting !!

possible cause is chronyd being blocked. Use show sockets to check 
limactl shell cp1 ss -ltpn
l shell cp1 chronyc sources
l shell cp1 chronyc sourcestats
chrony config: /etc/chrony/chrony.conf
l shell cp1 chronyc -n tracking
https://github.com/SuperQ/chrony/blob/master/doc/faq.adoc#34-is-chronyd-allowed-to-step-the-system-clock

one can consider using the nocerttimecheck option which allows the user to set the number of times that the time can be synced without checking validation and expiration.

#### Prometheus Node scraping node-exporter or state-metrics
- curl the endpoint: curl 10.101.88.172:9100/metrics
success
- why is prometheus not getting data to grafana

- prometheus shows node exporter and state metrics offline
  "no active targets in this scrape pool"
  where is scrape pool defined?

  There is a selector-label mismatch between serviceMonitor and node-exporter service