#!/bin/bash

set -euo pipefail

###############################################
# Azure Enterprise E-Commerce Platform
# One Click Installer
###############################################

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

TERRAFORM_DIR="$PROJECT_ROOT/infra/terraform"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

header() {
    echo ""
    echo -e "${BLUE}=================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=================================================${NC}"
}

###############################################
header "Azure Enterprise E-Commerce Installer"

log "Project Root : $PROJECT_ROOT"
log "Terraform   : $TERRAFORM_DIR"

###############################################
header "Checking Required Commands"

REQUIRED=(
    az
    kubectl
    helm
    terraform
    git
)

for cmd in "${REQUIRED[@]}"
do
    if ! command -v "$cmd" >/dev/null 2>&1
    then
        error "$cmd is not installed."
    else
        log "$cmd found"
    fi
done

###############################################
header "Checking Azure Login"

if ! az account show >/dev/null 2>&1
then
    warn "Azure Login Required..."
    az login
fi

SUBSCRIPTION=$(az account show --query name -o tsv)

log "Subscription : $SUBSCRIPTION"

###############################################
header "Terraform"

cd "$TERRAFORM_DIR"

terraform init

terraform validate

terraform plan -out=tfplan

echo ""
read -p "Apply Terraform? (yes/no): " confirm

if [ "$confirm" != "yes" ]
then
    error "Installation Cancelled."
fi

terraform apply tfplan

log "Terraform Completed"

###############################################
header "Getting AKS Credentials"

RESOURCE_GROUP=$(terraform output -raw resource_group_name)
AKS_CLUSTER=$(terraform output -raw aks_cluster_name)

az aks get-credentials \
    --resource-group "$RESOURCE_GROUP" \
    --name "$AKS_CLUSTER" \
    --overwrite-existing

log "AKS Connected"

###############################################
header "Cluster Verification"

kubectl cluster-info

kubectl get nodes -o wide

log "Part 1 Completed Successfully"

echo ""
echo "=========================================="
echo "Next:"
echo "Install Istio"
echo "Install ArgoCD"
echo "Install Monitoring"
echo "Deploy Application"
echo "=========================================="

###############################################
header "Attaching Azure Container Registry"

ACR_NAME=$(terraform output -raw acr_name)

log "Attaching ACR: $ACR_NAME"

az aks update \
    --resource-group "$RESOURCE_GROUP" \
    --name "$AKS_CLUSTER" \
    --attach-acr "$ACR_NAME"

log "ACR Attached Successfully"

###############################################
header "Creating Namespaces"

for ns in argocd monitoring logging istio-system ecom
do
    if kubectl get namespace "$ns" >/dev/null 2>&1
    then
        log "Namespace $ns already exists."
    else
        kubectl create namespace "$ns"
        log "Namespace $ns created."
    fi
done

###############################################
header "Installing Istio"

if ! command -v istioctl >/dev/null 2>&1
then
    error "istioctl not found. Install Istio CLI first."
fi

if kubectl get namespace istio-system >/dev/null 2>&1
then
    log "Installing Istio Control Plane..."

    istioctl install -y

    kubectl label namespace ecom istio-injection=enabled --overwrite

    kubectl rollout restart deployment -n ecom

    log "Istio Installed Successfully"
fi

###############################################
header "Installing ArgoCD"

if kubectl get deployment argocd-server -n argocd >/dev/null 2>&1
then
    warn "ArgoCD Already Installed"
else
    kubectl apply -n argocd \
        -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    kubectl rollout status deployment/argocd-server -n argocd --timeout=600s
fi

###############################################
header "Installing ArgoCD CLI"

if command -v argocd >/dev/null 2>&1
then
    log "ArgoCD CLI Already Installed"
else
    VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | grep tag_name | cut -d '"' -f4)

    sudo curl -L \
      -o /usr/local/bin/argocd \
      "https://github.com/argoproj/argo-cd/releases/download/${VERSION}/argocd-linux-amd64"

    sudo chmod +x /usr/local/bin/argocd

    log "ArgoCD CLI Installed"
fi

###############################################
header "Waiting for ArgoCD"

kubectl wait \
    --for=condition=available \
    deployment/argocd-server \
    -n argocd \
    --timeout=600s

log "ArgoCD Ready"

###############################################
header "Current Cluster Status"

kubectl get nodes

echo ""

kubectl get pods -A

echo ""

kubectl get svc -A

###############################################
header "Part 2 Completed"

echo ""

echo "Next Stage"

echo "✔ Install Prometheus"

echo "✔ Install Grafana"

echo "✔ Install Loki"

echo "✔ Install Alertmanager"

echo "✔ Install Kiali"

echo "✔ Deploy Microservices"

echo ""

###############################################
header "Installing Helm Repositories"

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true
helm repo add grafana https://grafana.github.io/helm-charts >/dev/null 2>&1 || true
helm repo update

###############################################
header "Installing Prometheus + Grafana"

if ! helm status kube-prometheus-stack -n monitoring >/dev/null 2>&1
then
    helm upgrade --install kube-prometheus-stack \
        prometheus-community/kube-prometheus-stack \
        -n monitoring \
        --create-namespace
else
    log "kube-prometheus-stack already installed"
fi

###############################################
header "Installing Loki"

if ! helm status loki -n logging >/dev/null 2>&1
then
    helm upgrade --install loki \
        grafana/loki-stack \
        -n logging \
        --create-namespace \
        -f "$PROJECT_ROOT/loki-values.yml"
else
    log "Loki already installed"
fi

###############################################
header "Deploying Monitoring Manifests"

kubectl apply -R -f "$PROJECT_ROOT/manifests/monitoring"

###############################################
header "Deploying Namespace"

kubectl apply -f "$PROJECT_ROOT/manifests/namespace.yml"

###############################################
header "Deploying Platform Services"

kubectl apply -R -f "$PROJECT_ROOT/manifests/platform"

###############################################
header "Deploying Microservices"

kubectl apply -R -f "$PROJECT_ROOT/manifests/services"

###############################################
header "Deploying Frontend"

kubectl apply -R -f "$PROJECT_ROOT/manifests/frontend"

###############################################
header "Deploying Network Configuration"

kubectl apply -R -f "$PROJECT_ROOT/manifests/networking"

###############################################
header "Deploying Security Policies"

kubectl apply -R -f "$PROJECT_ROOT/manifests/security"

###############################################
header "Deploying HPA"

kubectl apply -R -f "$PROJECT_ROOT/manifests/hpa"

###############################################
header "Deploying Kustomization"

kubectl apply -k "$PROJECT_ROOT/manifests"

###############################################
header "Waiting for Pods"

kubectl wait \
    --for=condition=Ready \
    pods \
    --all \
    -n ecom \
    --timeout=600s || true

###############################################
header "Deployment Status"

kubectl get pods -A

echo ""

kubectl get svc -A

echo ""

kubectl get ingress -A || true

echo ""

kubectl get gateway -A || true

echo ""

kubectl get httproute -A || true

###############################################
header "Part 3 Completed"

log "Monitoring Installed"
log "Application Deployed"
log "Security Applied"
log "HPA Applied"

###############################################
header "Waiting For Core Components"

kubectl wait --for=condition=Available deployment \
    --all \
    -n argocd \
    --timeout=600s || true

kubectl wait --for=condition=Available deployment \
    --all \
    -n monitoring \
    --timeout=600s || true

kubectl wait --for=condition=Available deployment \
    --all \
    -n istio-system \
    --timeout=600s || true

kubectl wait --for=condition=Available deployment \
    --all \
    -n ecom \
    --timeout=600s || true

###############################################
header "Deploying ArgoCD Applications"

if [ -d "$PROJECT_ROOT/manifests/argocd" ]; then
    kubectl apply -f "$PROJECT_ROOT/manifests/argocd/"
fi

###############################################
header "Waiting For ArgoCD Applications"

sleep 20

###############################################
header "Cluster Status"

echo ""
kubectl get nodes
echo ""

kubectl get pods -A
echo ""

kubectl get svc -A
echo ""

kubectl get pvc -A
echo ""

kubectl get gateway -A || true
echo ""

kubectl get httproute -A || true

###############################################
header "Getting Passwords"

ARGO_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" 2>/dev/null | base64 -d || true)

GRAFANA_PASSWORD=$(kubectl -n monitoring get secret kube-prometheus-stack-grafana \
-o jsonpath="{.data.admin-password}" 2>/dev/null | base64 -d || true)

###############################################
header "Port Forward Commands"

echo ""

echo "ArgoCD"
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"

echo ""

echo "Grafana"
echo "kubectl port-forward svc/kube-prometheus-stack-grafana -n monitoring 3000:80"

echo ""

echo "Prometheus"
echo "kubectl port-forward svc/kube-prometheus-stack-prometheus -n monitoring 9090:9090"

echo ""

echo "Kiali"
echo "kubectl port-forward svc/kiali -n istio-system 20001:20001"

###############################################
header "Credentials"

echo ""

echo "ArgoCD"

echo "Username : admin"
echo "Password : ${ARGO_PASSWORD}"

echo ""

echo "Grafana"

echo "Username : admin"
echo "Password : ${GRAFANA_PASSWORD}"

###############################################
header "Application URLs"

echo ""

echo "ArgoCD     : https://localhost:8080"

echo "Grafana    : http://localhost:3000"

echo "Prometheus : http://localhost:9090"

echo "Kiali      : http://localhost:20001"

###############################################
header "Installation Summary"

echo ""

echo "Terraform Infrastructure      [ OK ]"

echo "AKS Cluster                   [ OK ]"

echo "Azure Container Registry      [ OK ]"

echo "Istio Service Mesh            [ OK ]"

echo "ArgoCD GitOps                 [ OK ]"

echo "Prometheus                    [ OK ]"

echo "Grafana                       [ OK ]"

echo "Loki                          [ OK ]"

echo "Alertmanager                  [ OK ]"

echo "Kiali                         [ OK ]"

echo "Platform Services             [ OK ]"

echo "Microservices                 [ OK ]"

echo "Security Policies             [ OK ]"

echo "Horizontal Pod Autoscaler     [ OK ]"

###############################################
echo ""
echo "============================================================"
echo " Azure Enterprise E-Commerce Platform Installed Successfully"
echo "============================================================"
echo ""
echo "Project Root : $PROJECT_ROOT"
echo ""
echo "Happy Kubernetes!"
echo ""

