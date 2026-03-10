#!/bin/bash
set -e

MASTER_IP="${master_ip}"

apt-get update -y
apt-get install -y containerd curl apt-transport-https ca-certificates gpg

# Disable swap
swapoff -a
sed -i '/swap/d' /etc/fstab

# Kernel modules
modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Sysctl settings
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

# Configure containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

# IMPORTANT FIX
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd

# Kubernetes repo
mkdir -p /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key \
 | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" \
 | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update -y
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo "Waiting for Kubernetes API..."

until curl -k https://$${MASTER_IP}:6443/healthz; do
  echo "Master not ready yet..."
  sleep 10
done

echo "Waiting for join command..."

until curl -sf http://$${MASTER_IP}/join.sh > /dev/null; do
  echo "join.sh not ready yet..."
  sleep 10
done

curl -s http://$${MASTER_IP}/join.sh -o /join.sh

chmod +x /join.sh

bash /join.sh