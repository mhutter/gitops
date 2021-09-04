# GitOps repo

## Getting started

```sh
kubectl taint node --all node-role.kubernetes.io/master:NoSchedule-
kubectl -n kube-system create secret generic hcloud --from-literal=token=...
kubectl -n kube-system create secret generic hcloud-csi --from-literal=token=...
kubectl apply -f  https://github.com/hetznercloud/hcloud-cloud-controller-manager/releases/download/v1.12.0/ccm.yaml
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f install.yml
```

## Documentation

### ArgoCD

Connect to the WebGUI:

```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

* docs: https://argo-cd.readthedocs.io/en/stable/
* API reference: https://localhost:8080/swagger-ui#operation/ApplicationService_Create

### cert-manager

* Securing Ingress Resources: https://cert-manager.io/docs/usage/ingress/

### ingress-nginx

* Custom ConfigMap https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/
* Ingress Annotations: https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/
