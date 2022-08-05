# Azure Resources Setup (using terraform)

## 1. Login to Azure

```shell
az login
```

Output

```json
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "Example home tenant GUID",
    "id": "Example subscription GUID",
    "isDefault": true,
    "managedByTenants": [],
    "name": "My_Subscription",
    "state": "Enabled",
    "tenantId": "Example tenant GUID",
    "user": {
      "name": "me@mail.com",
      "type": "user"
    }
  }
]
```

## 2. Set the subscription Id

```shell
az account set --subscription "Example subscription GUID"
```

## 3. Create a Service Principal

```shell
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/85aee6d8-25f2-42c3-b3bc-a04a444e1a75"
```

Output

```json
{
  "appId": "e6c70588-55e5-4c42-b617-8dc4313bd62a",
  "displayName": "azure-cli-2022-08-05-19-23-48",
  "password": "dnR8Q~0kT-zFecOXHY-GqvfyigPVkmuC76ot5dmH",
  "tenant": "3794603d-0a24-4383-a08e-8b1ca6991b59"
}
```

For Reference:

- [Terraform Azure Example](https://learn.hashicorp.com/tutorials/terraform/azure-build?in=terraform/azure-get-started)
