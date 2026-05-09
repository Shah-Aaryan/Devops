#!/bin/bash
# ============================================================
# k8s-monitoring-setup.sh
# Run ONCE on the K8s / Monitoring EC2 server (Ubuntu 22.04)
# Usage: chmod +x k8s-monitoring-setup.sh && sudo ./k8s-monitoring-setup.sh
# ============================================================
set -e

echo "=== [1/5] System update ==="
apt-get update -y && apt-get upgrade -y
apt-get install -y curl wget git apt-transport-https

echo "=== [2/5] Installing Docker ==="
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker ubuntu
systemctl enable --now docker

echo "=== [3/5] Installing kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

echo "=== [4/5] Installing Minikube (single-node K8s) ==="
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
# Start minikube as ubuntu user
sudo -u ubuntu minikube start --driver=docker --cpus=2 --memory=4096

echo "=== [5/5] Installing Helm ==="
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo ""
echo "============================================================"
echo "✅ K8s + Docker setup complete on this server."
echo "   Next: clone your repo and run the monitoring stack"
echo "   Public IP: $(curl -s ifconfig.me)"
echo "============================================================"
