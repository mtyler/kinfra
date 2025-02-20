# install the kubernetes-dashboard
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "1"
  name: kubernetes-dashboard
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: kubernetes-dashboard
  project: default
  source:
    path: dashboard
    chart: kubernetes-dashboard
    repoURL: https://kubernetes.github.io
    targetRevision: 'v7.10.4'
    helm:
      releaseName: kubernetes-dashboard
      parameters:
      - name: "kong.proxy.http.enabled"
        value: "true"
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - ServerSideApply=true
