#!/bin/bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
TF_DIR="$PROJECT_ROOT/infra/terraform"

GREEN="\033[0;32m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

header "Azure Enterprise Cleanup"

if ! command -v az >/dev/null 2>&1; then
    echo "Azure CLI is not installed."
    exit 1
fi

if ! az account show >/dev/null 2>&1; then
    echo "Please login first:"
    az login
fi

echo ""
read -p "This will DELETE all Azure resources. Type YES to continue: " CONFIRM

if [ "$CONFIRM" != "YES" ]; then
    echo "Cancelled."
    exit 0
fi

###############################################
header "Terraform Destroy"

cd "$TF_DIR"

terraform init

terraform destroy -auto-approve

###############################################
header "Cleaning Local kubeconfig"

CLUSTER_NAME=$(kubectl config current-context 2>/dev/null || true)

if [ -n "$CLUSTER_NAME" ]; then
    kubectl config delete-context "$CLUSTER_NAME" || true
    kubectl config delete-cluster "$CLUSTER_NAME" || true
fi

###############################################
header "Cleaning Local Cache"

rm -rf .terraform
rm -f tfplan
rm -f terraform.tfstate.backup

###############################################
header "Cleanup Completed"

echo ""
echo "✓ Azure Resources Deleted"
echo "✓ AKS Deleted"
echo "✓ ACR Deleted"
echo "✓ VNet Deleted"
echo "✓ Log Analytics Deleted"
echo "✓ Storage Account Deleted"
echo "✓ Key Vault Deleted"
echo "✓ Managed Identity Deleted"
echo "✓ Load Balancer Deleted"
echo "✓ Public IP Deleted"
echo "✓ Terraform State Cleaned"
echo "✓ Local kubeconfig Cleaned"

echo ""
echo "Project cleanup completed successfully."
