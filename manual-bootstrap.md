# Manual bootstrap

```bash
az group create --name tfstate-rg --location westeurope

az storage account create \
  --name tfstatesg \
  --resource-group tfstate-rg \
  --location westeurope \
  --sku Standard_LRS

ACCOUNT_KEY=$(az storage account keys list --resource-group tfstate-rg --account-name tfstatesg --query '[0].value' -o tsv)

az storage container create \
  --name tfstate \
  --account-name tfstatesg \
  --account-key $ACCOUNT_KEY

```