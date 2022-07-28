# Azure Resources Setup

### Login to Azure

```shell
az login
```

### Query Azure region names

Region location is required when creating a Azure Resource Group. Using the following command to search the available regions available by the logged in account:

```shell
az account list-locations \
  --query "[].{DisplayName:displayName,Region:name}" \
  --out table
```

If you want the region names sorted alphabetically:

```shell
az account list-locations \
  --query "[].name" \
  --out table \
  | sort
```

### Create new resource group

> **Remember:** Resource Group names must be unique globally across Azure.

```shell
az group create \
  --name rgbeskardev \
  --location westus2 \
  --tags app=beskar env=dev
```

### Create Storage Account

For more information on creating storage accounts, checkout the Microsoft documentation on [Create a storage account](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-cli).

```shell
az storage account create \
 --name stbeskardev \
 --resource-group rgbeskardev \
 --location westus2 \
 --sku Standard_LRS \
 --kind StorageV2 \
 --min-tls-version TLS1_2 \
 --tags app=beskar env=dev
```

Description of the storage account create command above:

- The name of the storage account has a prefix of 'st'.
- The sku value is for 'Local Redundant Storage' (LRS).
- The kind value is for the latest and most flexible storage type.
- The min-tls-version value is set to the latest and recommended version.

> **WARN**
> By default the File Service has the 'Soft Delete' option enabled for 7 days. I would prefer that this value is set to disabled during creation. Needs more investigation.

Used to add tags after the resource is created.

```shell
resource=$(az resource show -g rgbeskardev -n stbeskardev --resource-type Microsoft.Storage/storageAccounts --query "id" --output tsv)
az tag create --resource-id $resource --tags app=beskar env=dev
```
