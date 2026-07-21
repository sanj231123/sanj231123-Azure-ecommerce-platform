# Azure Enterprise E-Commerce Platform

# Complete Deployment Guide

---

# Table of Contents

1. Introduction
2. System Requirements
3. Repository Structure
4. Install Required Software
5. Azure Login
6. Clone Repository
7. Verify Installation

---

# Introduction

This guide demonstrates how to deploy the Azure Enterprise E-Commerce Platform from a fresh Ubuntu machine.

By the end of this guide, you will have:

- Azure Infrastructure
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Kubernetes Cluster
- GitHub Actions CI
- ArgoCD GitOps
- Istio Service Mesh
- Prometheus
- Grafana
- Loki
- Kiali

---

# System Requirements

## Operating System

Ubuntu 22.04 LTS

---

## Hardware

Minimum

CPU : 4 Core

RAM : 8 GB

Disk : 100 GB

Internet Connection

Azure Subscription

GitHub Account

Docker Hub Account (Optional)

---

# Repository Structure

```

Azure-Ecommerce-Platform/

app/

infra/

manifests/

docs/

.github/

README.md

```

---

# Update Ubuntu

```

sudo apt update

sudo apt upgrade -y

sudo apt autoremove -y

sudo apt autoclean

```

Verify

```

cat /etc/os-release

```

---

# Install Common Packages

```

sudo apt install -y \
curl \
wget \
git \
vim \
nano \
jq \
zip \
unzip \
tree \
net-tools \
apt-transport-https \
ca-certificates \
gnupg \
lsb-release \
software-properties-common

```

Verify

```

git --version

curl --version

wget --version

tree --version

```

---

# Install Git

```

sudo apt install git -y

```

Configure

```

git config --global user.name "<YOUR_NAME>"

git config --global user.email "<YOUR_EMAIL>"

```

Verify

```

git config --list

```

---

# Install Docker

Remove old packages

```

sudo apt remove docker \
docker-engine \
docker.io \
containerd \
runc

```

Install dependencies

```

sudo apt update

sudo apt install -y \
ca-certificates \
curl \
gnupg

```

Add Docker GPG key

```

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

```

Set repository

```

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list

```

Install Docker

```

sudo apt update

sudo apt install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin

```

Enable Docker

```

sudo systemctl enable docker

sudo systemctl start docker

```

Add current user

```

sudo usermod -aG docker $USER

newgrp docker

```

Verify

```

docker version

docker info

docker ps

```

---

# Install Azure CLI

Download

```

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

```

Verify

```

az version

```

---

# Install kubectl

```

curl -LO \
https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl

chmod +x kubectl

sudo mv kubectl /usr/local/bin/

```

Verify

```

kubectl version --client

```

---

# Install Helm

Download

```

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

```

Verify

```

helm version

```

---

# Install Terraform

Install HashiCorp Key

```

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

```

Repository

```

echo \
"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com \
$(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

```

Install

```

sudo apt update

sudo apt install terraform -y

```

Verify

```

terraform version

```

---

# Install Azure Kubelogin

```

az aks install-cli

```

Verify

```

kubelogin --version

```

---

# Clone Repository

```

git clone https://github.com/<YOUR_GITHUB_USERNAME>/Azure-Ecommerce-Platform.git

```

Move

```

cd Azure-Ecommerce-Platform

```

Verify

```

tree -L 2

```

Expected

```

app/

infra/

manifests/

docs/

README.md

```

---

# Verify Installed Software

Docker

```

docker version

```

Azure CLI

```

az version

```

Terraform

```

terraform version

```

kubectl

```

kubectl version --client

```

Helm

```

helm version

```

Git

```

git version

```

---

# Project Prerequisites Checklist

| Component | Status |
|------------|--------|
| Ubuntu | ✅ |
| Git | ✅ |
| Docker | ✅ |
| Azure CLI | ✅ |
| kubectl | ✅ |
| Helm | ✅ |
| Terraform | ✅ |
| Internet | ✅ |
| Azure Subscription | ✅ |
| GitHub Account | ✅ |

---

# Azure Login

Authenticate to Azure.

```bash
az login
```

Verify the authenticated account.

```bash
az account show
```

List all subscriptions.

```bash
az account list -o table
```

If multiple subscriptions are available, select one.

```bash
az account set --subscription "<SUBSCRIPTION_NAME>"
```

Verify.

```bash
az account show --output table
```

---

# Environment Variables

Export commonly used variables.

```bash
export RESOURCE_GROUP="<RESOURCE_GROUP>"
export LOCATION="<AZURE_REGION>"
export STORAGE_ACCOUNT="<STORAGE_ACCOUNT>"
export CONTAINER_NAME="tfstate"
export AKS_CLUSTER="<AKS_CLUSTER_NAME>"
export ACR_NAME="<ACR_NAME>"
export KEYVAULT_NAME="<KEYVAULT_NAME>"
```

Example

```bash
export RESOURCE_GROUP="rg-dev"
export LOCATION="eastus"
export STORAGE_ACCOUNT="stterraform123"
export CONTAINER_NAME="tfstate"
export AKS_CLUSTER="aks-prod"
export ACR_NAME="myacr123"
export KEYVAULT_NAME="kv-prod"
```

Verify.

```bash
echo $RESOURCE_GROUP
echo $LOCATION
echo $AKS_CLUSTER
```

---

# Create Resource Group

```bash
az group create \
--name $RESOURCE_GROUP \
--location $LOCATION
```

Verify.

```bash
az group list -o table
```

---

# Create Storage Account (Terraform Backend)

```bash
az storage account create \
--resource-group $RESOURCE_GROUP \
--name $STORAGE_ACCOUNT \
--sku Standard_LRS \
--kind StorageV2
```

Verify.

```bash
az storage account list -o table
```

---

# Create Blob Container

Retrieve the storage account key.

```bash
ACCOUNT_KEY=$(az storage account keys list \
--resource-group $RESOURCE_GROUP \
--account-name $STORAGE_ACCOUNT \
--query "[0].value" \
-o tsv)
```

Create the container.

```bash
az storage container create \
--name $CONTAINER_NAME \
--account-name $STORAGE_ACCOUNT \
--account-key $ACCOUNT_KEY
```

Verify.

```bash
az storage container list \
--account-name $STORAGE_ACCOUNT \
--account-key $ACCOUNT_KEY \
-o table
```

---

# Configure Terraform Backend

Update the backend configuration (`backend.tf`) with your values.

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "<RESOURCE_GROUP>"
    storage_account_name = "<STORAGE_ACCOUNT>"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

---

# Initialize Terraform

```bash
cd infra/terraform
```

```bash
terraform init
```

Upgrade providers if required.

```bash
terraform init -upgrade
```

---

# Validate Terraform

```bash
terraform validate
```

Format configuration.

```bash
terraform fmt -recursive
```

---

# Review Infrastructure Plan

```bash
terraform plan
```

Optionally save the plan.

```bash
terraform plan -out=tfplan
```

---

# Deploy Infrastructure

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
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Azure Key Vault
- Log Analytics Workspace
- Managed Identity
- Storage Account

---

# Verify Resource Group

```bash
az resource list \
--resource-group $RESOURCE_GROUP \
-o table
```

---

# Verify AKS Cluster

```bash
az aks list -o table
```

Display AKS details.

```bash
az aks show \
--resource-group $RESOURCE_GROUP \
--name $AKS_CLUSTER
```

---

# Configure kubectl

Download AKS credentials.

```bash
az aks get-credentials \
--resource-group $RESOURCE_GROUP \
--name $AKS_CLUSTER \
--overwrite-existing
```

Verify.

```bash
kubectl cluster-info
```

List nodes.

```bash
kubectl get nodes
```

Display node details.

```bash
kubectl describe nodes
```

---

# Verify Azure Container Registry

```bash
az acr list -o table
```

Retrieve the login server.

```bash
az acr show \
--name $ACR_NAME \
--query loginServer \
-o tsv
```

Login to ACR.

```bash
az acr login \
--name $ACR_NAME
```

Verify.

```bash
az acr repository list \
--name $ACR_NAME \
-o table
```

---

# Verify Azure Key Vault

```bash
az keyvault list -o table
```

Display Key Vault details.

```bash
az keyvault show \
--name $KEYVAULT_NAME
```

Create a sample secret.

```bash
az keyvault secret set \
--vault-name $KEYVAULT_NAME \
--name demo-secret \
--value "demo-value"
```

Verify.

```bash
az keyvault secret list \
--vault-name $KEYVAULT_NAME \
-o table
```

---

# Verify Log Analytics

```bash
az monitor log-analytics workspace list -o table
```

---

# Verify Managed Identity

```bash
az identity list -o table
```

---

# Verify Kubernetes Cluster

Nodes

```bash
kubectl get nodes
```

Namespaces

```bash
kubectl get ns
```

System Pods

```bash
kubectl get pods -A
```

Services

```bash
kubectl get svc -A
```

---

# Infrastructure Checklist

| Component | Status |
|-----------|--------|
| Azure Login | ✅ |
| Resource Group | ✅ |
| Storage Account | ✅ |
| Terraform Backend | ✅ |
| Terraform Init | ✅ |
| Terraform Apply | ✅ |
| AKS Cluster | ✅ |
| ACR | ✅ |
| Key Vault | ✅ |
| Log Analytics | ✅ |
| Managed Identity | ✅ |
| kubectl Configured | ✅ |


---

# Docker Image Build

Move to the project root.

```bash
cd Azure-Ecommerce-Platform
```

List application folders.

```bash
ls app
```

Expected services:

- frontend
- api-gateway
- auth-service
- user-service
- product-service
- cart-service
- order-service
- payment-service
- notification-service

---

# Login to Azure Container Registry

```bash
az acr login --name $ACR_NAME
```

Verify login.

```bash
docker info
```

---

# Build Docker Images

## Frontend

```bash
docker build -t $ACR_NAME.azurecr.io/frontend:latest ./app/frontend
```

## API Gateway

```bash
docker build -t $ACR_NAME.azurecr.io/api-gateway:latest ./app/api-gateway
```

## Auth Service

```bash
docker build -t $ACR_NAME.azurecr.io/auth-service:latest ./app/auth-service
```

## User Service

```bash
docker build -t $ACR_NAME.azurecr.io/user-service:latest ./app/user-service
```

## Product Service

```bash
docker build -t $ACR_NAME.azurecr.io/product-service:latest ./app/product-service
```

## Cart Service

```bash
docker build -t $ACR_NAME.azurecr.io/cart-service:latest ./app/cart-service
```

## Order Service

```bash
docker build -t $ACR_NAME.azurecr.io/order-service:latest ./app/order-service
```

## Payment Service

```bash
docker build -t $ACR_NAME.azurecr.io/payment-service:latest ./app/payment-service
```

## Notification Service

```bash
docker build -t $ACR_NAME.azurecr.io/notification-service:latest ./app/notification-service
```

---

# Verify Images

```bash
docker images
```

---

# Push Images to Azure Container Registry

```bash
docker push $ACR_NAME.azurecr.io/frontend:latest
docker push $ACR_NAME.azurecr.io/api-gateway:latest
docker push $ACR_NAME.azurecr.io/auth-service:latest
docker push $ACR_NAME.azurecr.io/user-service:latest
docker push $ACR_NAME.azurecr.io/product-service:latest
docker push $ACR_NAME.azurecr.io/cart-service:latest
docker push $ACR_NAME.azurecr.io/order-service:latest
docker push $ACR_NAME.azurecr.io/payment-service:latest
docker push $ACR_NAME.azurecr.io/notification-service:latest
```

Verify repositories.

```bash
az acr repository list --name $ACR_NAME -o table
```

---

# Kubernetes Namespace

```bash
kubectl create namespace ecom
```

Label the namespace for Istio.

```bash
kubectl label namespace ecom istio-injection=enabled --overwrite
```

Verify.

```bash
kubectl get ns
```

---

# Kubernetes Secrets

Create application secrets.

```bash
kubectl apply -f manifests/secrets/
```

Verify.

```bash
kubectl get secrets -n ecom
```

---

# ConfigMaps

```bash
kubectl apply -f manifests/configmaps/
```

Verify.

```bash
kubectl get configmap -n ecom
```

---

# Persistent Volumes

```bash
kubectl apply -f manifests/storage/
```

Verify.

```bash
kubectl get pv
kubectl get pvc -n ecom
```

---

# Deploy Databases

## MySQL

```bash
kubectl apply -f manifests/mysql/
```

Verify.

```bash
kubectl get pods -n ecom
```

---

## Redis

```bash
kubectl apply -f manifests/redis/
```

Verify.

```bash
kubectl get pods -n ecom
```

---

## RabbitMQ

```bash
kubectl apply -f manifests/rabbitmq/
```

Verify.

```bash
kubectl get pods -n ecom
```

---

# Deploy Microservices

Apply all application manifests.

```bash
kubectl apply -f manifests/services/
```

Verify.

```bash
kubectl get deploy -n ecom
```

---

# Deploy Frontend

```bash
kubectl apply -f manifests/frontend/
```

---

# Deploy API Gateway

```bash
kubectl apply -f manifests/api-gateway/
```

---

# Verify Pods

```bash
kubectl get pods -n ecom
```

Watch pod status.

```bash
kubectl get pods -n ecom -w
```

---

# Verify Deployments

```bash
kubectl get deployment -n ecom
```

---

# Verify ReplicaSets

```bash
kubectl get rs -n ecom
```

---

# Verify Services

```bash
kubectl get svc -n ecom
```

---

# Describe a Pod

```bash
kubectl describe pod <POD_NAME> -n ecom
```

---

# View Logs

```bash
kubectl logs <POD_NAME> -n ecom
```

Follow logs.

```bash
kubectl logs -f <POD_NAME> -n ecom
```

---

# Execute Inside a Pod

```bash
kubectl exec -it <POD_NAME> -n ecom -- /bin/sh
```

or

```bash
kubectl exec -it <POD_NAME> -n ecom -- bash
```

---

# Rolling Restart

```bash
kubectl rollout restart deployment -n ecom
```

Restart a single deployment.

```bash
kubectl rollout restart deployment frontend -n ecom
```

---

# Rollout Status

```bash
kubectl rollout status deployment/frontend -n ecom
```

---

# Scale Deployment

```bash
kubectl scale deployment frontend --replicas=3 -n ecom
```

---

# Verify Application

Pods.

```bash
kubectl get pods -n ecom
```

Services.

```bash
kubectl get svc -n ecom
```

Endpoints.

```bash
kubectl get endpoints -n ecom
```

---

# Health Check

```bash
kubectl top nodes
kubectl top pods -n ecom
```

---

# Deployment Checklist

| Component | Status |
|-----------|--------|
| Docker Images Built | ✅ |
| Images Pushed to ACR | ✅ |
| Namespace Created | ✅ |
| Secrets Applied | ✅ |
| ConfigMaps Applied | ✅ |
| Persistent Storage | ✅ |
| MySQL Running | ✅ |
| Redis Running | ✅ |
| RabbitMQ Running | ✅ |
| Microservices Running | ✅ |
| Frontend Running | ✅ |
| API Gateway Running | ✅ |
| Services Available | ✅ |

---

# GitHub Actions CI/CD

This project uses GitHub Actions for Continuous Integration.

Pipeline stages:

- Detect changed microservice
- Build Docker image
- Push image to Azure Container Registry
- Update Kubernetes manifests
- Commit manifest changes
- Trigger ArgoCD Sync

---

# Required GitHub Secrets

Repository

Settings

Secrets and Variables

Actions

Add the following secrets.

| Secret | Description |
|---------|-------------|
| AZURE_CLIENT_ID | Azure Service Principal Client ID |
| AZURE_TENANT_ID | Azure Tenant ID |
| AZURE_SUBSCRIPTION_ID | Azure Subscription ID |
| ACR_NAME | Azure Container Registry Name |

Optional

| Secret | Description |
|---------|-------------|
| GITOPS_USER_NAME | Git Username |
| GITOPS_EMAIL | Git Email |

---

# Verify Workflow

Push a commit.

```bash
git add .

git commit -m "Update application"

git push origin main
```

Open GitHub.

Actions

Verify pipeline execution.

Expected stages

- Detect Changes
- Azure Login
- Docker Build
- Docker Push
- Manifest Update
- Git Commit

---

# Verify Image in ACR

```bash
az acr repository list \
--name $ACR_NAME \
-o table
```

Verify image tags.

```bash
az acr repository show-tags \
--name $ACR_NAME \
--repository frontend
```

---

# Install ArgoCD

Create namespace.

```bash
kubectl create namespace argocd
```

Install ArgoCD.

```bash
kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Verify.

```bash
kubectl get pods -n argocd
```

---

# Access ArgoCD UI

Port Forward

```bash
kubectl port-forward svc/argocd-server \
-n argocd \
8080:443
```

Browser

```
https://localhost:8080
```

---

# Get Initial Password

```bash
kubectl -n argocd \
get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d
```

Username

```
admin
```

---

# Register Git Repository

Example

```
https://github.com/<YOUR_USERNAME>/Azure-Ecommerce-Platform.git
```

Repository Path

```
manifests
```

Branch

```
main
```

---

# Create Application

```bash
kubectl apply -f manifests/argocd/application.yaml
```

Verify

```bash
kubectl get applications -n argocd
```

---

# Sync Application

CLI

```bash
argocd app sync ecommerce
```

Or

Use Sync button in ArgoCD UI.

---

# Verify GitOps

```bash
kubectl get pods -n ecom
```

Modify Deployment.

Commit.

Push.

Verify ArgoCD automatically syncs.

---

# Install Istio

Download

```bash
curl -L https://istio.io/downloadIstio | sh -
```

Move

```bash
cd istio-*
```

Install

```bash
bin/istioctl install -y
```

Verify

```bash
kubectl get pods -n istio-system
```

---

# Enable Sidecar Injection

```bash
kubectl label namespace ecom \
istio-injection=enabled \
--overwrite
```

Restart deployments.

```bash
kubectl rollout restart deployment \
-n ecom
```

---

# Verify Sidecars

```bash
kubectl get pods -n ecom
```

Each application pod should show

```
2/2 Running
```

---

# Deploy Gateway

```bash
kubectl apply -f manifests/istio/gateway.yaml
```

Verify

```bash
kubectl get gateway -A
```

---

# Deploy VirtualService / HTTPRoute

```bash
kubectl apply -f manifests/istio/
```

Verify

```bash
kubectl get virtualservice -A

kubectl get httproute -A
```

---

# Verify Ingress Gateway

```bash
kubectl get svc -n istio-system
```

---

# Test Application

Browser

```
http://<EXTERNAL-IP>
```

or

```
http://localhost
```

depending on deployment.

---

# Traffic Verification

```bash
kubectl logs deployment/api-gateway \
-n ecom
```

Check requests flowing to services.

---

# Rolling Update

```bash
kubectl rollout restart deployment frontend \
-n ecom
```

Verify

```bash
kubectl rollout status deployment/frontend \
-n ecom
```

---

# GitOps Verification

Update any manifest.

Commit.

Push.

Verify

- GitHub Actions executes
- Image pushed to ACR
- Manifest updated
- ArgoCD Sync
- Pod recreated automatically

---

# Part 4 Checklist

| Component | Status |
|-----------|--------|
| GitHub Actions | ✅ |
| Azure Login | ✅ |
| Docker Push | ✅ |
| ACR Updated | ✅ |
| ArgoCD Installed | ✅ |
| GitOps Enabled | ✅ |
| Auto Sync | ✅ |
| Istio Installed | ✅ |
| Sidecar Injection | ✅ |
| Gateway | ✅ |
| VirtualService / HTTPRoute | ✅ |
| Traffic Routing | ✅ |
| Application Accessible | ✅ |


---

# Monitoring Stack

This project uses the following observability components.

| Component | Purpose |
|-----------|----------|
| Prometheus | Metrics Collection |
| Grafana | Dashboards |
| Loki | Centralized Logging |
| Kiali | Service Mesh Visualization |
| Metrics Server | Resource Metrics |
| HPA | Horizontal Scaling |

---

# Install Prometheus

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

kubectl create namespace monitoring

helm install monitoring prometheus-community/kube-prometheus-stack \
-n monitoring
```

Verify

```bash
kubectl get pods -n monitoring
```

---

# Access Grafana

```bash
kubectl port-forward svc/monitoring-grafana \
-n monitoring \
3000:80
```

Browser

```
http://localhost:3000
```

Retrieve password

```bash
kubectl get secret \
-n monitoring \
monitoring-grafana \
-o jsonpath="{.data.admin-password}" | base64 -d
```

Username

```
admin
```

---

# Install Loki

```bash
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

kubectl create namespace logging

helm install loki grafana/loki-stack \
-n logging
```

Verify

```bash
kubectl get pods -n logging
```

---

# Configure Grafana Data Sources

Add

- Prometheus
- Loki

Verify dashboards are loading metrics and logs.

---

# Install Kiali

```bash
kubectl apply \
-f https://raw.githubusercontent.com/istio/istio/release-1.24/samples/addons/kiali.yaml
```

Verify

```bash
kubectl get pods -n istio-system
```

Port Forward

```bash
kubectl port-forward svc/kiali \
-n istio-system \
20001:20001
```

Browser

```
http://localhost:20001
```

---

# Install Metrics Server

```bash
kubectl apply \
-f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Verify

```bash
kubectl top nodes

kubectl top pods -n ecom
```

---

# Horizontal Pod Autoscaler

Deploy HPA

```bash
kubectl apply -f manifests/hpa/
```

Verify

```bash
kubectl get hpa -n ecom
```

Describe

```bash
kubectl describe hpa -n ecom
```

---

# Network Policies

Deploy

```bash
kubectl apply -f manifests/security/
```

Verify

```bash
kubectl get networkpolicy -n ecom
```

Expected

- Default Deny
- MySQL Policy
- Redis Policy
- RabbitMQ Policy
- Prometheus Access
- Istio Access

---

# Verify Complete Application

Nodes

```bash
kubectl get nodes
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
kubectl get deploy -A
```

Ingress

```bash
kubectl get gateway -A

kubectl get httproute -A
```

Storage

```bash
kubectl get pvc -A

kubectl get pv
```

Autoscaling

```bash
kubectl get hpa -A
```

---

# Health Checks

Cluster

```bash
kubectl cluster-info
```

Component Status

```bash
kubectl get componentstatus
```

Node Resources

```bash
kubectl top nodes
```

Pod Resources

```bash
kubectl top pods -A
```

---

# Troubleshooting

Pods Not Starting

```bash
kubectl describe pod <pod-name> -n ecom

kubectl logs <pod-name> -n ecom
```

Restart Deployment

```bash
kubectl rollout restart deployment/<deployment-name> -n ecom
```

Events

```bash
kubectl get events -A --sort-by=.metadata.creationTimestamp
```

Istio

```bash
kubectl get pods -n istio-system
```

ArgoCD

```bash
kubectl get pods -n argocd
```

Prometheus

```bash
kubectl get pods -n monitoring
```

Loki

```bash
kubectl get pods -n logging
```

Kiali

```bash
kubectl get pods -n istio-system
```

---

# Production Validation Checklist

| Validation | Status |
|------------|--------|
| AKS Running | ✅ |
| ACR Available | ✅ |
| GitHub Actions Working | ✅ |
| ArgoCD Sync Healthy | ✅ |
| Istio Installed | ✅ |
| Gateway Reachable | ✅ |
| Frontend Accessible | ✅ |
| API Gateway Working | ✅ |
| All Microservices Running | ✅ |
| MySQL Running | ✅ |
| Redis Running | ✅ |
| RabbitMQ Running | ✅ |
| Prometheus Collecting Metrics | ✅ |
| Grafana Dashboards | ✅ |
| Loki Receiving Logs | ✅ |
| Kiali Showing Service Graph | ✅ |
| HPA Active | ✅ |
| Network Policies Applied | ✅ |

---

# Cleanup

Delete Application

```bash
kubectl delete namespace ecom
```

Delete Monitoring

```bash
kubectl delete namespace monitoring
```

Delete Logging

```bash
kubectl delete namespace logging
```

Delete ArgoCD

```bash
kubectl delete namespace argocd
```

Delete Istio

```bash
kubectl delete namespace istio-system
```

Destroy Azure Infrastructure

```bash
cd infra/terraform

terraform destroy
```

or

```bash
az group delete \
--name <RESOURCE_GROUP> \
--yes \
--no-wait
```

---

# Conclusion

You have successfully deployed a production-style Azure Kubernetes microservices platform featuring:

- Azure AKS
- Azure Container Registry
- Terraform Infrastructure as Code
- GitHub Actions CI/CD
- ArgoCD GitOps
- Istio Service Mesh
- Prometheus Monitoring
- Grafana Dashboards
- Loki Centralized Logging
- Kiali Service Mesh Observability
- Horizontal Pod Autoscaler
- Kubernetes Network Policies

This architecture demonstrates modern cloud-native DevOps practices and is suitable as a portfolio project for interviews and learning.

---
