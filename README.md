# GitOps repo

Docs: https://argo-cd.readthedocs.io/en/stable/

## Getting started

```sh
kubectl taint node --all node-role.kubernetes.io/master:NoSchedule-
kubectl -n kube-system create secret generic hcloud --from-literal=token=...
kubectl apply -f  https://github.com/hetznercloud/hcloud-cloud-controller-manager/releases/download/v1.12.0/ccm.yaml
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f install.yml
```
