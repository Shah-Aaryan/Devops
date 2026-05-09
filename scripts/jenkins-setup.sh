#!/bin/bash
# ============================================================
# jenkins-setup.sh
# Run this ONCE on the Jenkins EC2 server (Ubuntu 22.04)
# Usage: chmod +x jenkins-setup.sh && sudo ./jenkins-setup.sh
# ============================================================
set -e

echo "=== [1/6] System update ==="
apt-get update -y && apt-get upgrade -y

echo "=== [2/6] Installing Java 17 ==="
apt-get install -y openjdk-17-jdk

echo "=== [3/6] Installing Jenkins ==="
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get update -y
apt-get install -y jenkins
systemctl enable --now jenkins

echo "=== [4/6] Installing Docker ==="
apt-get install -y ca-certificates curl gnupg lsb-release
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
usermod -aG docker jenkins
usermod -aG docker ubuntu
systemctl enable --now docker

echo "=== [5/6] Installing Trivy (security scanner) ==="
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | tee /etc/apt/sources.list.d/trivy.list
apt-get update -y
apt-get install -y trivy

echo "=== [6/6] Installing SonarQube via Docker ==="
docker run -d \
  --name sonarqube \
  --restart unless-stopped \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  sonarqube:lts-community

echo ""
echo "====================================================="
echo "✅ Jenkins setup complete!"
echo "  Jenkins UI  : http://$(curl -s ifconfig.me):8080"
echo "  SonarQube   : http://$(curl -s ifconfig.me):9000"
echo ""
echo "Initial Jenkins password:"
cat /var/lib/jenkins/secrets/initialAdminPassword
echo "====================================================="
