# PlaybackSpace — DevOps on AWS

> Full-stack video platform deployed on AWS with a complete CI/CD, containerisation, and observability stack.

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Node.js · Express · MongoDB · Cloudinary |
| **Frontend** | React · Vite |
| **Containerisation** | Docker · Docker Compose |
| **CI/CD** | Jenkins (CI) + GitOps Jenkinsfile (CD) |
| **Infrastructure** | AWS EC2 · Terraform |
| **Orchestration** | Kubernetes (Minikube) |
| **Code Quality** | SonarQube · Trivy |
| **Monitoring** | Prometheus · Grafana · Node Exporter |

---

## 📁 Repository Structure

```
Devops/
├── backend/                  # Express API
│   ├── Dockerfile
│   └── .env.example
├── client/                   # Vite/React frontend
│   ├── Dockerfile
│   └── .env.example
├── kubernetes/               # K8s manifests
│   ├── backend.yaml
│   └── client.yaml
├── terraform/                # AWS infrastructure
│   ├── main.tf               # VPC, SG, EC2 instances
│   ├── variables.tf
│   └── outputs.tf
├── monitoring/               # Observability stack
│   ├── prometheus.yml
│   └── grafana/provisioning/datasources/
├── scripts/                  # Server bootstrap scripts
│   ├── jenkins-setup.sh
│   └── k8s-monitoring-setup.sh
├── shared-library/vars/      # Jenkins shared library functions
├── GitOps/Jenkinsfile        # CD pipeline
├── Jenkinsfile               # CI pipeline
├── docker-compose.yml        # Full local/server stack
└── sonar-project.properties  # SonarQube config
```

---

## 🚀 Quick Start

### 1. Provision AWS Infrastructure

```bash
cd terraform
terraform init
terraform apply -var="my_ip=$(curl -s ifconfig.me)/32" -auto-approve
```

### 2. Bootstrap servers

```bash
# Jenkins server
scp -i devops-key.pem scripts/jenkins-setup.sh ubuntu@<JENKINS_IP>:~/
ssh -i devops-key.pem ubuntu@<JENKINS_IP> "chmod +x jenkins-setup.sh && sudo ./jenkins-setup.sh"

# K8s / monitoring server
scp -i devops-key.pem scripts/k8s-monitoring-setup.sh ubuntu@<K8S_IP>:~/
ssh -i devops-key.pem ubuntu@<K8S_IP> "chmod +x k8s-monitoring-setup.sh && sudo ./k8s-monitoring-setup.sh"
```

### 3. Start monitoring stack on K8s server

```bash
git clone https://github.com/Shah-Aaryan/Devops.git && cd Devops
docker compose up -d prometheus grafana node-exporter
```

### 4. Deploy app to Kubernetes

```bash
kubectl create namespace playback-space
kubectl create secret generic backend-secrets --namespace=playback-space \
  --from-env-file=backend/.env
kubectl apply -f kubernetes/
```

### 5. Trigger Jenkins pipeline

```
Jenkins → playback-space-CI → Build with Parameters
  CLIENT_DOCKER_TAG  : v1
  BACKEND_DOCKER_TAG : v1
```

---

## 🌐 Access URLs

| Service | URL |
|---|---|
| Jenkins | `http://<JENKINS_IP>:8080` |
| SonarQube | `http://<JENKINS_IP>:9000` |
| Grafana | `http://<K8S_IP>:3000` |
| Prometheus | `http://<K8S_IP>:9090` |
| Client App | `http://<K8S_IP>:31000` |
| Backend API | `http://<K8S_IP>:31100/api/v1/` |

---

## 📖 Full Deployment Guide

See [`aws-deployment-guide.md`](.gemini/antigravity/brain/4dc97e47-e518-418e-b8c9-1556024f2a44/artifacts/aws-deployment-guide.md) for the complete step-by-step walkthrough including architecture diagrams, troubleshooting, and Grafana dashboard IDs.
