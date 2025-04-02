#!/bin/bash

set -e

APP_NAME="terraform-sp-investorflow"
ENV_FILE=".env"

echo "🔐 Creating Service Principal: $APP_NAME..."

SP_JSON=$(az ad sp create-for-rbac \
  --name "$APP_NAME" \
  --role="Contributor" \
  --scopes="/subscriptions/$(az account show --query id -o tsv)" \
  --sdk-auth)

ARM_CLIENT_ID=$(echo "$SP_JSON" | jq -r '.clientId')
ARM_CLIENT_SECRET=$(echo "$SP_JSON" | jq -r '.clientSecret')
ARM_SUBSCRIPTION_ID=$(echo "$SP_JSON" | jq -r '.subscriptionId')
ARM_TENANT_ID=$(echo "$SP_JSON" | jq -r '.tenantId')

cat <<EOF > "$ENV_FILE"
ARM_CLIENT_ID=$ARM_CLIENT_ID
ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
ARM_TENANT_ID=$ARM_TENANT_ID
EOF

echo "✅ .env file generated:"
cat "$ENV_FILE"
