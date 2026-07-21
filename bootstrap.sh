#!/bin/bash

set -e

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

log(){ echo -e "${GREEN}[INFO]${NC} $1"; }
warn(){ echo -e "${YELLOW}[WARN]${NC} $1"; }
fail(){ echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

if [ "$EUID" -ne 0 ]; then
    fail "Run with sudo: sudo ./bootstrap.sh"
fi

log "Updating Ubuntu..."

apt-get update -y

log "Installing base packages..."

apt-get install -y \
    curl \
    wget \
    unzip \
    git \
    jq \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common

########################################################
# Docker
########################################################

if ! command -v docker >/dev/null 2>&1
then
    log "Installing Docker..."

    curl -fsSL https://get.docker.com | sh

    usermod -aG docker $SUDO_USER || true
else
    log "Docker already installed."
fi

########################################################
# Azure CLI
########################################################

if ! command -v az >/dev/null 2>&1
then
    log "Installing Azure CLI..."

    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
else
    log "Azure CLI already installed."
fi

########################################################
# Terraform
########################################################

if ! command -v terraform >/dev/null 2>&1
then
    log "Installing Terraform..."

    wget -qO- https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor \
    > /usr/share/keyrings/hashicorp-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list

    apt-get update

    apt-get install -y terraform
else
    log "Terraform already installed."
fi

########################################################
# kubectl
########################################################

if ! command -v kubectl >/dev/null 2>&1
then
    log "Installing kubectl..."

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    rm kubectl
else
    log "kubectl already installed."
fi

########################################################
# Helm
########################################################

if ! command -v helm >/dev/null 2>&1
then
    log "Installing Helm..."

    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
    log "Helm already installed."
fi

########################################################
# Istioctl
########################################################

if ! command -v istioctl >/dev/null 2>&1
then
    log "Installing Istio CLI..."

    curl -L https://istio.io/downloadIstio | sh -

    ISTIO_DIR=$(find . -maxdepth 1 -type d -name "istio-*" | head -1)

    cp "$ISTIO_DIR/bin/istioctl" /usr/local/bin/

    rm -rf "$ISTIO_DIR"
else
    log "Istioctl already installed."
fi

########################################################
# ArgoCD CLI
########################################################

if ! command -v argocd >/dev/null 2>&1
then
    log "Installing ArgoCD CLI..."

    VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | jq -r .tag_name)

    curl -L \
    -o /usr/local/bin/argocd \
    https://github.com/argoproj/argo-cd/releases/download/${VERSION}/argocd-linux-amd64

    chmod +x /usr/local/bin/argocd
else
    log "ArgoCD CLI already installed."
fi

########################################################

echo ""
echo "==============================================="
echo " Bootstrap Completed Successfully"
echo "==============================================="
echo ""

echo "Installed Versions"

echo ""

docker --version || true
az version | head -1 || true
terraform version | head -1
kubectl version --client
helm version --short
istioctl version --short
argocd version --client

echo ""
echo "Next:"
echo ""
echo "chmod +x install.sh"
echo "./install.sh"
echo ""
