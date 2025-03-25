# skeleton-terraform-project
This is a sample terraform project for integrating with Saviynt Identity Cloud.


---

##  Overview

With this sample project, you can:

- Get started with managing Saviynt Identity Cloud using the Saviynt Terraform provider.

---

##  Features

Following resources are available for management: 
- Security System
- Endpoint
- Connections

Following connectors are available:
- Active Directory(AD)
- REST

---

## Directory Structure
```
.
├── LICENSE
├── README.md
├── docs
│   ├── data-sources
│   │   ├── datasource_endpoints.md
│   │   └── datasource_security_systems.md
│   ├── index.md
│   └── resources
│       ├── resource_ad_connection.md
│       ├── resource_endpoint.md
│       ├── resource_rest_connection.md
│       └── resource_security_system.md
├── environment
│   ├── dev
│   │   ├── dev.tf
│   │   ├── dev.tfvars
│   │   └── variable.tf
│   ├── prod
│   │   ├── prod.tf
│   │   ├── prod.tfvars
│   │   └── variable.tf
│   └── test
│       ├── test.tf
│       ├── test.tfvars
│       └── variable.tf
├── provider
│   └── terraform-provider-saviynt_v1.0.0
├── provider.tf
└── resources
    ├── connections
    │   └── sample_connector.tf
    ├── endpoints
    │   └── sample_endpoint.tf
    └── security_systems
        └── sample_security_system.tf

```

##  Requirements

- Terraform version `>= 1.8+`
- Go programming language `>= 1.21+` (required for development and contributions)
- Saviynt credentials (url, username and password)

---

## Getting started

Before installing the provider, ensure that you have the following dependencies installed:

### **1. Install Terraform**  
Terraform is required to use this provider. Install Terraform using one of the following methods:

#### **For macOS (using Homebrew)**
```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

#### **For Windows (using chocolatey)**
```sh
choco install terraform
```

#### **For Manual installation or other platforms**
Visit [Terraform Installation](https://developer.hashicorp.com/terraform/install) for installation instructions.

### 2. Install Go

#### **For macOS (using Homebrew)**
```sh
brew install go
```
#### **For Windows (using chocolatey)**
```sh
choco install golang
```
#### **For Manual installation or other platforms**
Visit [Go Setup](https://go.dev/doc/install) for installation instructions.

To use this provider, follow these steps:  

### **3. Download the Binary**  
Copy the provider binary from provider directory to the Go bin directory: 

```sh
cp provider/terraform-provider-saviynt_v1.0.0 <GOBIN PATH>
chmod +x GOBIN/terraform-provider-saviynt_v1.0.0

```

### 4. Configure `.terraformrc` or `terraform.rc`

Create the file at:

- **macOS/Linux**: `~/.terraformrc`
- **Windows**: `%APPDATA%\terraform.rc`

```hcl
provider_installation {
  dev_overrides {
    "<PROVIDER SOURCE PATH>" = "<PATH>"
  }
  direct {}
}
```

Replace `<PATH>` and `<PROVIDER SOURCE PATH>` with your actual GOBIN path and the provider location respectively.

### Terraform Configuration

```hcl
terraform {
  required_providers {
    saviynt = {
      source  = "<PROVIDER SOURCE PATH>"
      version = "1.0.0"
    }
  }
}

provider "saviynt" {
  server_url  = "YOUR_SAVIYNT_URL"
  username   = "YOUR_SAVIYNT_USERNAME"
  password   = "YOUR_SAVIYNT_PASSWORD"
}
```

Replace the `<PROVIDER SOURCE PATH>` with your provider path. The configuration should look similar to `registry.terraform.io/local/saviynt`.

---

##  Usage

Here's an example of defining and managing a resource:

```hcl
resource "saviynt_security_system_resource" "sample" {
  systemname          = "sample_security_system"
  display_name        = "sample security system"
  hostname            = "sample.system.com"
  port                = "443"
  access_add_workflow = "sample_workflow"
}
```
Here's an example of using the data source block:
```hcl
data "saviynt_security_systems_datasource" "all" {
  connection_type = "REST"
  max             = 10
  offset          = 0
}

output "systems" {
  value = data.saviynt_security_systems_datasource.all.results
}
```

---

##  Available Resources

###  Resource

- [saviynt_security_system_resource](docs/resources/resource_security_system.md): Manages lifecycle (create, update, read) of security systems. Supports workflows, connectors, password policies and more.
- [saviynt_endpoints_resource](docs/resources/resource_endpoint.md): For managing endpoints definitions used by security systems.
- [saviynt_ad_connection_resource](docs/resources/resource_ad_connection.md): For managing AD connections.
- [saviynt_rest_connection_resource](docs/resources/resource_rest_connection.md): For managing REST connections.

###  Data Source

- [saviynt_security_systems_datasource](docs/data-sources/datasource_security_systems.md): Retrieves a list of configured security systems filtered by systemname, connection_type, etc.
- [saviynt_datasource_endpoints](docs/data-sources/datasource_endpoints.md): Retrieves a list of endpoints.

---

## Here are the Terraform commands to be run:

1. To initialise Terraform
```bash
terraform init
```

2. To plan the changes from the .tf file and .tfstate file
```bash
terraform plan
```

3. To apply the changes.
```bash
terraform apply
```

## Terraform Workspaces

1. To create a new workspace

```bash
terraform workspaces new <workspace-name>
```

2. To select a workspace

```bash
terraform workspaces select <workspace-name>
```

3. To apply changes to an environment
```bash
terraform apply -var-file="<values.tfvars>"
```

Here is a sample invocation example:
```bash
terraform apply -var-file="dev.tfvars"
```
---

##  License

This project is licensed under the Apache License 2.0. Refer to [LICENSE](LICENSE) for full license details.

---

##  Support

If you encounter any issues or have questions, please open an issue on our GitHub page.

---
