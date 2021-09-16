#!/usr/bin/env bash
set -e -u -o pipefail -x

export KUBECONFIG=/etc/kubernetes/admin.conf
export DEBIAN_FRONTEND=noninteractive

target_version="${SYSTEM_UPGRADE_PLAN_LATEST_VERSION#v}"
target_minor="$(echo "$target_version" | cut -d. -f1-2)"

echo \
  "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/${target_minor}/xUbuntu_20.04/ /" \
  > /etc/apt/sources.list.d/crio.list

apt-get update
apt-get install -y --allow-change-held-packages \
  "kubeadm=${target_version}-00" \
  "kubelet=${target_version}-00" \
  "kubectl=${target_version}-00"
apt-mark hold kubeadm kubelet kubectl

# Upgrade cluster itself if required
current_version="$(kubectl version --short | awk '/^Server/{print $3}')"
if [[ "$current_version" != "$target_version" ]]; then
  kubeadm upgrade plan "$SYSTEM_UPGRADE_PLAN_LATEST_VERSION"
  kubeadm upgrade apply --yes "$SYSTEM_UPGRADE_PLAN_LATEST_VERSION"
  kubectl apply \
    -f https://docs.projectcalico.org/manifests/calico.yaml
fi

kubeadm upgrade node

old_pid="$(pgrep kubelet)"
systemctl daemon-reload
systemctl restart kubelet

while [[ "$(pgrep kubelet)" == "$old_pid" ]]; do sleep 1; done
while ! curl -sSk -m1 https://127.0.0.1:10250/healthz; do sleep 1; done
