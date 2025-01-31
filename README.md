# azure-hub-and-spoke
Terraform script to create azure hub and spoke network topology

# Creating a Service Principal in the Azure Portal

This guide provides step-by-step instructions to create a Service Principal in the Azure Portal. This involves three main tasks:

1. Creating an Application in Azure Active Directory, which will create an associated Service Principal.
2. Generating a Client Secret for the Azure Active Directory Application, which will be used for authentication.
3. Granting the Service Principal access to manage resources in your Azure subscriptions.

## 1. Creating an Application in Azure Active Directory

1. Navigate to the **Azure Active Directory** overview within the Azure Portal.
2. Select the **App Registration** blade.
3. Click the **New registration** button at the top to add a new Application.
4. Set the following values:
   - **Name**: A friendly identifier (e.g., `Terraform`)
   - **Supported Account Types**: Select `Accounts in this organizational directory only (single-tenant)`
   - **Redirect URI**: Choose `Web` for the URI type. The actual value can be left blank.
5. Click **Create**.
6. Once created, note the following details:
   - **Application (client) ID**
   - **Directory (tenant) ID**

## 2. Generating a Client Secret for the Azure Active Directory Application

1. Navigate to the newly created Azure Active Directory Application.
2. Select **Certificates & secrets**.
3. Click **New client secret**.
4. Enter a **Description** and select an **Expiry Date**.
5. Click **Add**.
6. Copy the generated **Client Secret** immediately (it will only be shown once).

## 3. Granting the Application Access to Manage Resources in Your Azure Subscription

1. Navigate to the **Subscriptions** blade in the Azure Portal.
2. Select the **Subscription** you want to use.
3. Click **Access Control (IAM)**.
4. Click **Add > Add role assignment**.
5. Select a **Role** that grants the necessary permissions (e.g., `Contributor` grants Read/Write access to all resources in the Subscription).
6. Search for and select the name of the Service Principal created earlier.
7. Click **Save**.

## Summary

You have successfully created a Service Principal in Azure Active Directory, generated a Client Secret, and granted it permission to manage resources within your Azure Subscription. These credentials (Client ID, Client Secret, Tenant ID, and Subscription ID) can now be used to authenticate Terraform or other automation tools in Azure.

### Example Usage in Terraform

```hcl
provider "azurerm" {
  subscription_id = "<your-subscription-id>"
  client_id       = "<your-client-id>"
  client_secret   = "<your-client-secret>"
  tenant_id       = "<your-tenant-id>"
  features {}
}
```

### To Test the Script
create a terraform.tfvars file in the root directory with the following 
client_id = "<your-client-id>"
client_secret = "<your-client-secret>"
tenant_id = "<your-tenant-id>"<
hub_subscription_id="<your-hub-subscription-id>"
spoke_subscription_id="<your-spoke-subscription-id>"