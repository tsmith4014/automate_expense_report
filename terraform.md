# Comprehensive Terraform Deployment Guide for Flask on Oracle Cloud

## Overview

This README outlines the steps to deploy a Flask application on an Oracle Cloud instance using Terraform. It covers generating API keys, configuring Terraform, and setting up the necessary files.

## Prerequisites

- Oracle Cloud account with appropriate permissions.
- Terraform installed on your local machine.
- Basic understanding of Flask, Python, and cloud environments.

## Configuration Files

- **`main.tf`**: Contains resource definitions for Oracle Cloud.
- **`providers.tf`**: Configures the Terraform provider for Oracle Cloud.
- **`variables.tf`**: Declares variables for Terraform configuration.
- **`.env`**: Manages environment variables.

## Generating OCI API Key Pair

1. Log into your Oracle Cloud account and navigate to your user settings.
2. Create an API key and download the private key file. Note the fingerprint provided by Oracle.

## Setting Up the OCI `config` File

1. **Create `.oci` Directory**:
   ```bash
   mkdir ~/.oci
   ```
2. **Create `config` File**:
   ```bash
   nano ~/.oci/config
   ```
3. **Add Configuration Details**:
   Paste the following, replacing placeholders with your details:

   ```plaintext
   [DEFAULT]
   user=YOUR_USER_OCID
   fingerprint=YOUR_API_KEY_FINGERPRINT
   tenancy=YOUR_TENANCY_OCID
   region=YOUR_REGION
   key_file=PATH_TO_YOUR_PRIVATE_KEY
   ```

4. **Set File Permissions**:
   Change the private key file permissions:
   ```bash
   chmod 600 PATH_TO_YOUR_PRIVATE_KEY
   ```

## Terraform Configuration

### `.env` File Setup

Create a `.env` file with the following template:

```plaintext
# Oracle Cloud Credentials
TENANCY_OCID="Your Tenancy OCID"
USER_OCID="Your User OCID"
FINGERPRINT="Your API Key fingerprint"
PRIVATE_KEY_PATH="Your OCI private key path"

# Instance Configuration
REGION="Your region, e.g., us-ashburn-1"
COMPARTMENT_ID="Your Compartment OCID"
SUBNET_ID="Your Subnet OCID"
SSH_PUBLIC_KEY="Your SSH public key"
ORACLE_LINUX_IMAGE_ID="Your Oracle Linux Image OCID"
```

### `providers.tf`

```hcl
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
```

### `variables.tf`

```hcl
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_id" {}
variable "subnet_id" {}
variable "ssh_public_key" {}
variable "oracle_linux_image_id" {}
```

### `main.tf`

```hcl
resource "oci_core_instance" "flask_app_instance" {
  availability_domain = "Your availability domain"
  compartment_id      = var.compartment_id
  shape               = "Your instance shape"
  display_name        = "Your instance display name"

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  source_details {
    source_type = "image"
    source_id   = var.oracle_linux_image_id
  }
}
```

## Steps to Deploy

1. **Load Environment Variables**:

   ```bash
   source load_env.sh
   ```

2. **Initialize Terraform**:

   ```bash
   terraform init
   ```

3. **Plan and Apply Terraform Configuration**:

   ```bash
   terraform plan
   terraform apply
   ```

4. **Access the Instance**:

   ```bash
   ssh -i /path/to/your/private/key opc@YOUR_INSTANCE_PUBLIC_IP
   ```

5. **Deploy Flask Application**:
   - Install Python, Flask, and other dependencies.
   - Transfer your Flask application to the instance.
   - Configure and run your application using Gunicorn or a similar WSGI server.
   - Optionally, set up Nginx as a reverse proxy.

---

To select a specific profile when using the Oracle Cloud Infrastructure (OCI) CLI, you can use the --profile option in your commands. Each profile in your ~/.oci/config file corresponds to a set of configuration details, including user OCID, tenancy OCID, region, and key file. When you have multiple profiles, this option lets you specify which one to use for a given command.

Selecting a Profile for CLI Commands
To use a specific profile, append --profile profile_name to your OCI CLI commands. For example, to use the ORACLECLOUDDEPLOYMENT profile, you would structure your command like this:

```bash


oci some-service some-command --profile ORACLECLOUDDEPLOYMEN

```

---

## Conclusion

Following this guide helps you set up a Flask application on Oracle Cloud using Terraform. This process simplifies managing cloud resources and automating application deployment.
