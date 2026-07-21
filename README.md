# 🚀 Azure Enterprise E-Commerce Platform

![Azure](https://img.shields.io/badge/Azure-AKS-0078D4?style=for-the-badge&logo=microsoftazure)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.30-326CE5?style=for-the-badge&logo=kubernetes)
![Docker](https://img.shields.io/badge/Docker-Container-2496ED?style=for-the-badge&logo=docker)
![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?style=for-the-badge&logo=terraform)
![ArgoCD](https://img.shields.io/badge/ArgoCD-GitOps-EF7B4D?style=for-the-badge&logo=argo)
![GitHub Actions](https://img.shields.io/badge/GitHub-Actions-2088FF?style=for-the-badge&logo=githubactions)
![Istio](https://img.shields.io/badge/Istio-Service_Mesh-466BB0?style=for-the-badge&logo=istio)
![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-E6522C?style=for-the-badge&logo=prometheus)
![Grafana](https://img.shields.io/badge/Grafana-Dashboard-F46800?style=for-the-badge&logo=grafana)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

---

# 📌 Project Overview

Azure Enterprise E-Commerce Platform is a production-style cloud-native microservices application deployed on **Azure Kubernetes Service (AKS)** using **Terraform** and managed with a complete **GitOps CI/CD pipeline**.

The project demonstrates enterprise DevOps practices including Infrastructure as Code (IaC), Continuous Integration, Continuous Delivery, Kubernetes orchestration, Service Mesh, centralized monitoring, logging, autoscaling, and secure container deployments.

This repository is designed as a reusable reference implementation for DevOps engineers learning or implementing production-grade Kubernetes on Microsoft Azure.

---

# 🎯 Project Objectives

- Build complete Azure infrastructure using Terraform
- Deploy Kubernetes microservices on AKS
- Containerize applications using Docker
- Store images in Azure Container Registry (ACR)
- Automate CI using GitHub Actions
- Implement GitOps CD using ArgoCD
- Secure traffic with Istio Service Mesh
- Monitor workloads using Prometheus & Grafana
- Centralize logs with Loki
- Visualize service mesh using Kiali
- Configure Horizontal Pod Autoscaler (HPA)
- Apply Kubernetes Network Policies
- Demonstrate enterprise DevOps best practices

---

# ✨ Key Features

## Infrastructure

- Azure Resource Group
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Key Vault
- Azure Storage Account
- Azure Log Analytics Workspace
- Azure Managed Identity

---

## Kubernetes

- Multi-node AKS Cluster
- Namespace Isolation
- Deployments
- Services
- ConfigMaps
- Secrets
- Persistent Volumes
- Persistent Volume Claims
- Horizontal Pod Autoscaler
- Network Policies

---

## CI/CD

- GitHub Actions
- Automatic Docker Build
- Automatic Image Push
- GitOps Deployment
- ArgoCD Auto Sync
- Rolling Updates

---

## Service Mesh

- Istio Gateway
- Virtual Services
- Traffic Management
- Service Discovery
- mTLS Ready Architecture

---

## Monitoring

- Prometheus
- Grafana
- Loki
- Kiali
- Kubernetes Metrics Server

---

# 🏗 High-Level Architecture

```
                        Developer
                            │
                            ▼
                     GitHub Repository
                            │
                GitHub Actions CI Pipeline
                            │
                            ▼
               Azure Container Registry (ACR)
                            │
                            ▼
                     ArgoCD GitOps Sync
                            │
                            ▼
                Azure Kubernetes Service (AKS)
                            │
                 Istio Ingress Gateway
                            │
                            ▼
                    API Gateway Service
                            │
      ┌───────────────┬───────────────┬───────────────┐
      ▼               ▼               ▼
 Frontend      Authentication     User Service
                      │
                      ▼
              Product Service
                      │
                      ▼
               Cart Service
                      │
                      ▼
               Order Service
                      │
                      ▼
              Payment Service
                      │
                      ▼
           Notification Service

──────────────────────────────────────────────

Database Layer

MySQL
Redis
RabbitMQ

──────────────────────────────────────────────

Observability

Prometheus
Grafana
Loki
Kiali

```

---

# 🛠 Technology Stack

| Category | Technologies |
|----------|--------------|
| Cloud | Microsoft Azure |
| IaC | Terraform |
| Container | Docker |
| Orchestration | Kubernetes (AKS) |
| Container Registry | Azure Container Registry |
| GitOps | ArgoCD |
| CI | GitHub Actions |
| Service Mesh | Istio |
| Monitoring | Prometheus |
| Visualization | Grafana |
| Logging | Loki |
| Service Mesh Dashboard | Kiali |
| Database | MySQL |
| Cache | Redis |
| Message Queue | RabbitMQ |
| OS | Ubuntu Linux |
| Version Control | Git |

---

# 📂 Repository Structure

```
Azure-Ecommerce-Platform/

├── app/
│
├── api-gateway/
├── frontend/
├── auth-service/
├── user-service/
├── product-service/
├── cart-service/
├── order-service/
├── payment-service/
└── notification-service/
│
├── manifests/
│   ├── deployments/
│   ├── services/
│   ├── ingress/
│   ├── monitoring/
│   ├── security/
│   ├── autoscaling/
│   └── istio/
│
├── infra/
│   └── terraform/
│       ├── environments/
│       ├── modules/
│       └── backend/
│
├── .github/
│   └── workflows/
│
├── docs/
│
├── scripts/
│
├── install.sh
├── verify.sh
├── destroy.sh
│
├── README.md
│
└── LICENSE

```

---

# 📦 Microservices

| Service | Purpose |
|----------|---------|
| Frontend | React Web Application |
| API Gateway | API Routing |
| Authentication | User Authentication |
| User Service | User Management |
| Product Service | Product Catalog |
| Cart Service | Shopping Cart |
| Order Service | Order Processing |
| Payment Service | Payment Integration |
| Notification Service | Email & Notification |

---

# 🔄 Deployment Workflow

```
Developer
      │
      ▼
Git Commit
      │
      ▼
GitHub Repository
      │
      ▼
GitHub Actions
      │
      ▼
Docker Build
      │
      ▼
Push Images to ACR
      │
      ▼
Update Kubernetes Manifests
      │
      ▼
ArgoCD Detects Changes
      │
      ▼
Deploy to AKS
      │
      ▼
Istio Gateway
      │
      ▼
Production Traffic
```

---

# 📋 Prerequisites

Before deploying this project, ensure the following tools are installed:

- Azure CLI
- Terraform
- Docker
- kubectl
- Helm
- Git
- jq
- curl

Minimum Azure requirements:

- Azure Subscription
- Contributor Role
- Azure Resource Group
- Azure CLI Login

---

# 🚀 Quick Start

Clone the repository.

```bash
git clone https://github.com/<YOUR_GITHUB_USERNAME>/Azure-Ecommerce-Platform.git

cd Azure-Ecommerce-Platform
```

Verify the repository.

```bash
tree -L 2
```

Expected output

```
app/
infra/
manifests/
scripts/
docs/
.github/
README.md
```

---

# ⚙️ Environment Variables

Create the following environment variables.

Replace all placeholder values with your own Azure resources.

```bash
export RESOURCE_GROUP=<RESOURCE_GROUP>
export LOCATION=<AZURE_REGION>
export AKS_CLUSTER=<AKS_CLUSTER_NAME>
export ACR_NAME=<ACR_NAME>
export STORAGE_ACCOUNT=<STORAGE_ACCOUNT>
export KEYVAULT_NAME=<KEYVAULT_NAME>
```

Example

```bash
export RESOURCE_GROUP=rg-dev
export LOCATION=eastus
export AKS_CLUSTER=aks-prod
export ACR_NAME=myacr123
```

Verify

```bash
echo $RESOURCE_GROUP
echo $LOCATION
```

---

# ☁️ Azure Login

Login to Azure.

```bash
az login
```

Verify subscription.

```bash
az account show
```

List subscriptions.

```bash
az account list -o table
```

If multiple subscriptions exist.

```bash
az account set --subscription "<SUBSCRIPTION_NAME>"
```

Verify current subscription.

```bash
az account show --output table
```

---

# 📁 Create Resource Group

```bash
az group create \
--name $RESOURCE_GROUP \
--location $LOCATION
```

Verify

```bash
az group list -o table
```

---

# 🏗 Infrastructure Deployment (Terraform)

Move into Terraform directory.

```bash
cd infra/terraform
```

Initialize Terraform.

```bash
terraform init
```

Validate configuration.

```bash
terraform validate
```

Format Terraform code.

```bash
terraform fmt -recursive
```

Review execution plan.

```bash
terraform plan
```

Deploy infrastructure.

```bash
terraform apply
```

or

```bash
terraform apply --auto-approve
```

Terraform provisions:

- Resource Group
- Virtual Network
- Subnets
- AKS Cluster
- Azure Container Registry
- Azure Key Vault
- Log Analytics Workspace
- Storage Account
- Managed Identity

---

# ✅ Verify Terraform Resources

List resources.

```bash
az resource list \
--resource-group $RESOURCE_GROUP \
-o table
```

Verify AKS.

```bash
az aks list -o table
```

Verify ACR.

```bash
az acr list -o table
```

Verify Key Vault.

```bash
az keyvault list -o table
```

Verify Storage Account.

```bash
az storage account list -o table
```

---

# ☸ Configure kubectl

Download cluster credentials.

```bash
az aks get-credentials \
--resource-group $RESOURCE_GROUP \
--name $AKS_CLUSTER \
--overwrite-existing
```

Verify cluster.

```bash
kubectl cluster-info
```

List nodes.

```bash
kubectl get nodes
```

Check Kubernetes version.

```bash
kubectl version
```

---

# 🐳 Azure Container Registry

Login.

```bash
az acr login \
--name $ACR_NAME
```

Verify repositories.

```bash
az acr repository list \
--name $ACR_NAME \
-o table
```

---

# 🐳 Build Docker Images

Example for API Gateway.

```bash
docker build \
-t $ACR_NAME.azurecr.io/api-gateway:v1 \
./app/api-gateway
```

Frontend

```bash
docker build \
-t $ACR_NAME.azurecr.io/frontend:v1 \
./app/frontend
```

Repeat for all services.

- auth-service
- user-service
- product-service
- cart-service
- order-service
- payment-service
- notification-service

---

# 📤 Push Images

Example

```bash
docker push \
$ACR_NAME.azurecr.io/api-gateway:v1
```

Push remaining images.

```bash
docker push $ACR_NAME.azurecr.io/frontend:v1
docker push $ACR_NAME.azurecr.io/auth-service:v1
docker push $ACR_NAME.azurecr.io/user-service:v1
docker push $ACR_NAME.azurecr.io/product-service:v1
docker push $ACR_NAME.azurecr.io/cart-service:v1
docker push $ACR_NAME.azurecr.io/order-service:v1
docker push $ACR_NAME.azurecr.io/payment-service:v1
docker push $ACR_NAME.azurecr.io/notification-service:v1
```

Verify.

```bash
az acr repository list \
--name $ACR_NAME \
-o table
```

---

# 🔐 Azure Key Vault

List Key Vaults.

```bash
az keyvault list -o table
```

Create a secret.

```bash
az keyvault secret set \
--vault-name $KEYVAULT_NAME \
--name mysql-password \
--value "<PASSWORD>"
```

List secrets.

```bash
az keyvault secret list \
--vault-name $KEYVAULT_NAME \
-o table
```

---

# 📦 Kubernetes Namespace

Create namespace.

```bash
kubectl create namespace ecom
```

Verify.

```bash
kubectl get namespace
```

---

# 🚀 Deploy Kubernetes Resources

Deploy ConfigMaps.

```bash
kubectl apply -f manifests/configmap/
```

Deploy Secrets.

```bash
kubectl apply -f manifests/secrets/
```

Deploy Persistent Volumes.

```bash
kubectl apply -f manifests/storage/
```

Deploy Databases.

```bash
kubectl apply -f manifests/database/
```

Deploy Redis.

```bash
kubectl apply -f manifests/redis/
```

Deploy RabbitMQ.

```bash
kubectl apply -f manifests/rabbitmq/
```

Deploy Microservices.

```bash
kubectl apply -f manifests/deployments/
```

Deploy Services.

```bash
kubectl apply -f manifests/services/
```

Verify deployment.

```bash
kubectl get all -n ecom
```

Check pods.

```bash
kubectl get pods -n ecom
```

Check services.

```bash
kubectl get svc -n ecom
```

---

# ✅ Deployment Verification

Nodes

```bash
kubectl get nodes
```

Namespaces

```bash
kubectl get ns
```

Pods

```bash
kubectl get pods -A
```

Services

```bash
kubectl get svc -A
```

Deployments

```bash
kubectl get deployment -A
```

Persistent Volumes

```bash
kubectl get pv
```

Persistent Volume Claims

```bash
kubectl get pvc -A

---

# 🔄 Continuous Integration (GitHub Actions)

This project uses **GitHub Actions** to automate container image builds and push them to **Azure Container Registry (ACR)**.

## Workflow

```
Developer
     │
     ▼
Git Push
     │
     ▼
GitHub Actions
     │
     ▼
Docker Build
     │
     ▼
Security Scan (Optional)
     │
     ▼
Push Image to ACR
     │
     ▼
Update Kubernetes Manifest
     │
     ▼
Commit Manifest
```

---

# GitHub Secrets

Configure the following repository secrets.

| Secret | Description |
|---------|-------------|
| AZURE_CLIENT_ID | Azure Service Principal Client ID |
| AZURE_TENANT_ID | Azure Tenant ID |
| AZURE_SUBSCRIPTION_ID | Azure Subscription ID |
| ACR_NAME | Azure Container Registry Name |
| GITHUB_TOKEN | Automatically provided by GitHub |

Verify Secrets

```
GitHub Repository

↓

Settings

↓

Secrets and Variables

↓

Actions
```

---

# Trigger CI Pipeline

Commit code.

```bash
git add .

git commit -m "Update application"

git push origin main
```

Verify workflow.

```
GitHub

↓

Actions

↓

Workflow Runs
```

---

# Verify Images in ACR

```bash
az acr repository list \
--name $ACR_NAME \
-o table
```

List image tags.

```bash
az acr repository show-tags \
--name $ACR_NAME \
--repository frontend \
-o table
```

---

# 🚀 GitOps using ArgoCD

ArgoCD continuously synchronizes the Kubernetes cluster with the Git repository.

```
GitHub Repository
        │
        ▼
    ArgoCD
        │
        ▼
 Compare Desired State
        │
        ▼
 Apply Changes
        │
        ▼
 Kubernetes Cluster
```

---

# Install ArgoCD

Create namespace.

```bash
kubectl create namespace argocd
```

Install.

```bash
kubectl apply \
-n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Wait.

```bash
kubectl wait \
--for=condition=available \
deployment \
--all \
-n argocd \
--timeout=600s
```

---

# Verify Installation

```bash
kubectl get pods -n argocd
```

```bash
kubectl get svc -n argocd
```

---

# Access ArgoCD

Port Forward

```bash
kubectl port-forward \
svc/argocd-server \
8080:443 \
-n argocd
```

Open

```
https://localhost:8080
```

---

# Get Initial Password

```bash
kubectl \
-n argocd \
get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" \
| base64 -d
```

Username

```
admin
```

---

# Create Application

```bash
kubectl apply \
-f manifests/argocd/application.yaml
```

Verify

```bash
kubectl get applications \
-n argocd
```

---

# Sync Application

Automatic Sync

```bash
argocd app sync ecommerce
```

Application Status

```bash
argocd app get ecommerce
```

---

# Verify Deployment

```bash
kubectl get pods \
-n ecom
```

---

# 🌐 Istio Service Mesh

Istio provides

- Service Discovery

- Secure Communication

- Traffic Management

- Observability

- Load Balancing

- Canary Deployment

- Blue Green Deployment

---

# Install Istio

Download

```bash
curl -L https://istio.io/downloadIstio \
| sh -
```

Move

```bash
cd istio-*
```

Add to PATH

```bash
export PATH=$PWD/bin:$PATH
```

Install

```bash
istioctl install \
--set profile=demo \
-y
```

Verify

```bash
kubectl get pods \
-n istio-system
```

---

# Enable Sidecar Injection

```bash
kubectl label namespace ecom \
istio-injection=enabled \
--overwrite
```

Restart Deployments

```bash
kubectl rollout restart deployment \
-n ecom
```

Verify Sidecars

```bash
kubectl get pods \
-n ecom
```

Each pod should show

```
2/2 Running
```

---

# Deploy Gateway

```bash
kubectl apply \
-f manifests/istio/gateway.yaml
```

Deploy Virtual Service

```bash
kubectl apply \
-f manifests/istio/virtualservice.yaml
```

Deploy Destination Rules

```bash
kubectl apply \
-f manifests/istio/destinationrule.yaml
```

---

# Verify Istio

```bash
kubectl get gateway \
-A
```

```bash
kubectl get virtualservice \
-A
```

```bash
kubectl get destinationrule \
-A
```

---

# Check Ingress Gateway

```bash
kubectl get svc \
-n istio-system
```

---

# Verify Envoy Sidecars

```bash
kubectl get pods \
-n ecom \
-o wide
```

Describe pod.

```bash
kubectl describe pod <POD_NAME> \
-n ecom
```

---

# GitOps Deployment Flow

```
Developer

↓

Git Push

↓

GitHub Actions

↓

Docker Build

↓

Push Image to ACR

↓

Update Deployment YAML

↓

Commit Manifest

↓

ArgoCD Detects Change

↓

Automatic Sync

↓

Deploy to AKS

↓

Istio Gateway

↓

Production Traffic
```

---

# Verification Commands

GitHub Actions

```bash
gh run list
```

ArgoCD

```bash
kubectl get applications \
-n argocd
```

Pods

```bash
kubectl get pods \
-A
```

Services

```bash
kubectl get svc \
-A
```

Deployments

```bash
kubectl get deployment \
-A
```

Ingress

```bash
kubectl get gateway \
-A
```

Virtual Service

```bash
kubectl get virtualservice \
-A
```

Destination Rule

```bash
kubectl get destinationrule \
-A
```

Rollout Status

```bash
kubectl rollout status deployment/frontend \
-n ecom

---

# 📊 Monitoring Stack

This platform uses a complete observability stack to monitor infrastructure, applications, and service mesh traffic.

## Components

| Component | Purpose |
|-----------|---------|
| Prometheus | Metrics Collection |
| Grafana | Dashboards & Visualization |
| Loki | Centralized Logging |
| Kiali | Istio Service Mesh Dashboard |
| Metrics Server | Kubernetes Resource Metrics |

---

# Install Metrics Server

```bash
kubectl apply \
-f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Verify

```bash
kubectl get pods \
-n kube-system
```

Check Metrics

```bash
kubectl top nodes

kubectl top pods -A
```

---

# Install Prometheus & Grafana

Add Helm repository.

```bash
helm repo add prometheus-community \
https://prometheus-community.github.io/helm-charts

helm repo update
```

Create namespace.

```bash
kubectl create namespace monitoring
```

Install kube-prometheus-stack.

```bash
helm install monitoring \
prometheus-community/kube-prometheus-stack \
-n monitoring
```

Verify.

```bash
kubectl get pods \
-n monitoring
```

List Helm releases.

```bash
helm list -A
```

---

# Access Grafana

Port Forward

```bash
kubectl port-forward \
svc/monitoring-grafana \
3000:80 \
-n monitoring
```

Open

```
http://localhost:3000
```

Retrieve Admin Password

```bash
kubectl get secret \
monitoring-grafana \
-n monitoring \
-o jsonpath="{.data.admin-password}" \
| base64 -d
```

Default Username

```
admin
```

---

# Access Prometheus

```bash
kubectl port-forward \
svc/monitoring-kube-prometheus-prometheus \
9090:9090 \
-n monitoring
```

Open

```
http://localhost:9090
```

---

# Install Loki

Add Grafana Helm repository.

```bash
helm repo add grafana \
https://grafana.github.io/helm-charts

helm repo update
```

Create namespace.

```bash
kubectl create namespace logging
```

Install Loki.

```bash
helm install loki \
grafana/loki-stack \
-n logging
```

Verify.

```bash
kubectl get pods \
-n logging
```

---

# View Logs

Frontend

```bash
kubectl logs deployment/frontend \
-n ecom
```

API Gateway

```bash
kubectl logs deployment/api-gateway \
-n ecom
```

Payment Service

```bash
kubectl logs deployment/payment-service \
-n ecom
```

Stream Logs

```bash
kubectl logs \
-f deployment/frontend \
-n ecom
```

---

# Install Kiali

Add Helm repository.

```bash
helm repo add kiali \
https://kiali.org/helm-charts

helm repo update
```

Install.

```bash
helm install kiali-server \
kiali/kiali-server \
-n istio-system
```

Verify.

```bash
kubectl get pods \
-n istio-system
```

Access Dashboard

```bash
kubectl port-forward \
svc/kiali \
20001:20001 \
-n istio-system
```

Open

```
http://localhost:20001
```

---

# Horizontal Pod Autoscaler (HPA)

Deploy HPA.

```bash
kubectl apply \
-f manifests/autoscaling/
```

Verify.

```bash
kubectl get hpa \
-n ecom
```

Describe HPA.

```bash
kubectl describe hpa \
-n ecom
```

---

# Network Policies

Deploy Policies.

```bash
kubectl apply \
-f manifests/security/
```

Verify.

```bash
kubectl get networkpolicy \
-n ecom
```

Describe.

```bash
kubectl describe networkpolicy \
-n ecom
```

---

# Health Verification

Cluster

```bash
kubectl cluster-info
```

Nodes

```bash
kubectl get nodes
```

Namespaces

```bash
kubectl get ns
```

Pods

```bash
kubectl get pods -A
```

Deployments

```bash
kubectl get deployment -A
```

Services

```bash
kubectl get svc -A
```

Ingress / Gateway

```bash
kubectl get gateway -A

kubectl get virtualservice -A
```

Persistent Volumes

```bash
kubectl get pv

kubectl get pvc -A
```

Helm Releases

```bash
helm list -A
```

---

# Troubleshooting

## Pod Not Starting

```bash
kubectl describe pod <POD_NAME> \
-n <NAMESPACE>
```

View logs.

```bash
kubectl logs <POD_NAME> \
-n <NAMESPACE>
```

---

## Deployment Issues

```bash
kubectl rollout status deployment/<DEPLOYMENT_NAME> \
-n <NAMESPACE>
```

Restart deployment.

```bash
kubectl rollout restart deployment/<DEPLOYMENT_NAME> \
-n <NAMESPACE>
```

---

## ArgoCD Sync Issues

```bash
kubectl get applications \
-n argocd

kubectl describe application <APPLICATION_NAME> \
-n argocd
```

---

## Istio Issues

```bash
kubectl get gateway -A

kubectl get virtualservice -A

kubectl get destinationrule -A
```

---

## Terraform Issues

```bash
terraform validate

terraform plan

terraform apply
```

---

# Cleanup

Delete Kubernetes resources.

```bash
kubectl delete namespace ecom
kubectl delete namespace monitoring
kubectl delete namespace logging
kubectl delete namespace argocd
kubectl delete namespace istio-system
```

Remove Helm releases.

```bash
helm uninstall monitoring -n monitoring

helm uninstall loki -n logging

helm uninstall kiali-server -n istio-system
```

Delete Azure Resource Group.

```bash
az group delete \
--name <RESOURCE_GROUP> \
--yes \
--no-wait
```

Verify deletion.

```bash
az group list -o table
```

---

# Future Enhancements

- Azure Application Gateway Ingress Controller
- Azure Monitor Integration
- Azure Managed Prometheus
- Azure Managed Grafana
- Azure Policy for Kubernetes
- Azure Defender for Containers
- Velero Backup & Restore
- External Secrets Operator
- HashiCorp Vault Integration
- OpenTelemetry
- Jaeger Distributed Tracing
- Canary Deployments
- Blue-Green Deployments
- Multi-Cluster AKS
- Multi-Region Disaster Recovery

---

# Contributing

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push to your fork.
5. Open a Pull Request.

---

# License

This project is licensed under the MIT License.

---

# Author

**Sanjay Prajapati**

DevOps Engineer | Kubernetes | Azure | Terraform | GitOps | Docker | Linux

GitHub: https://github.com/sanj231123/sanj231123-Azure-ecommerce-platform

LinkedIn: https://www.linkedin.com/in/sanjay-prajapaati

---

# ⭐ Support

If you found this project useful, consider giving it a ⭐ on GitHub.

Happy Learning! 🚀



