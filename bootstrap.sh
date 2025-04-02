#!/bin/bash

set -e

# --- CONFIG ---
RESOURCE_GROUP="tfstate-rg"
STORAGE_ACCOUNT="tfstatesg"
CONTAINER_NAME="tfstate"
LOCATION="westeurope"
ACR_NAME="investorflowdevacr"
ACR_SKU="Basic"

# login
az account show > /dev/null 2>&1 || az login

# create rg
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# sa 
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --encryption-services blob

# sk
ACCOUNT_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query '[0].value' -o tsv)

# blob
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$ACCOUNT_KEY"

echo "✅ Remote state backend created"

# acr
az acr show --name "$ACR_NAME" --resource-group "$RESOURCE_GROUP" &>/dev/null || {
  echo "Creating ACR: $ACR_NAME"
  az acr create \
    --name "$ACR_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --sku "$ACR_SKU" \
    --location "$LOCATION" \
    --admin-enabled true
}

# svc principal
echo "Creating service principal for Terraform..."

SP_JSON=$(az ad sp create-for-rbac \
  --name "terraform-sp-investorflow" \
  --role="Contributor" \
  --scopes="/subscriptions/$(az account show --query id -o tsv)" \
  --sdk-auth)

echo "$SP_JSON" > terraform.azureauth.json

echo "✅ Service Principal created and saved to terraform.azureauth.json"

# export as env vars
export ARM_CLIENT_ID=$(echo "$SP_JSON" | jq -r .clientId)
export ARM_CLIENT_SECRET=$(echo "$SP_JSON" | jq -r .clientSecret)
export ARM_SUBSCRIPTION_ID=$(echo "$SP_JSON" | jq -r .subscriptionId)
export ARM_TENANT_ID=$(echo "$SP_JSON" | jq -r .tenantId)

echo
echo "⚙️ Terraform ENV Vars (export these if not using azureauth.json):"
echo "export ARM_CLIENT_ID=$ARM_CLIENT_ID"
echo "export ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET"
echo "export ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID"
echo "export ARM_TENANT_ID=$ARM_TENANT_ID"
