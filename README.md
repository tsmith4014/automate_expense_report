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

---

# Readme version 2, with some specific instance configuration details

## Overview

This guide details the process of deploying a Flask application on an Oracle Cloud instance using Terraform. The instructions are tailored to an Oracle Cloud Infrastructure (OCI) environment with specific instance configurations.

## Specific Oracle Instance Configuration

- **Region**: us-ashburn-1 (iad)
- **Instance Type**: VM.Standard.E2.1.Micro
- **OCPU Count**: 1
- **Memory**: 1 GB
- **Public IP Address**: 132.145.209.168
- **Username**: opc
- **Image**: Oracle-Linux-8.8-2023.09.26-0 -**SSH Key Name**: selfs.key

## Prerequisites

- An Oracle Cloud account.
- Terraform installed on your local machine.
- Basic knowledge of Flask, Python, Gunicorn, and optionally Nginx.
- SSH key pair for Oracle Cloud access.

## Step-by-Step Guide

### Step 1: Write Terraform Configuration for Oracle Cloud Instance

1. **Create a Terraform Configuration File (`main.tf`)**:

   - Include the OCI provider and instance details.
   - Example snippet:

     ```hcl
     provider "oci" {
       region = "us-ashburn-1"  # Your Oracle Cloud region
     }

     resource "oci_core_instance" "my_flask_app" {
       availability_domain = "AD-2"
       compartment_id      = "<Your-Compartment-ID>"
       shape               = "VM.Standard.E2.1.Micro"
       display_name        = "FlaskAppInstance"

       create_vnic_details {
         subnet_id = "<Your-Subnet-ID>"
       }

       metadata = {
         ssh_authorized_keys = file("/path/to/public/key")
       }

       image_id = "<Oracle-Linux-Image-ID>"  # Replace with Oracle Linux Image ID
     }
     ```

2. **Note**: Replace `<Your-Compartment-ID>`, `<Your-Subnet-ID>`, and `<Oracle-Linux-Image-ID>` with actual IDs from your Oracle Cloud setup.

### Step 2: Apply Terraform Configuration

1. **Initialize Terraform**:

   ```shell
   terraform init
   ```

2. **Apply Configuration**:
   ```shell
   terraform apply
   ```
   - Confirm the creation of the instance.

### Step 3: Install Necessary Software on the Instance

1. **SSH into the Instance**:

   ```shell
   ssh -i /path/to/private/key opc@132.145.209.168
   ```

2. **Install Python, pip, and Dependencies**:
   - Update the package manager.
   - Install Python, pip, and Flask dependencies.

### Step 4: Transfer Flask Application to the Instance

1. **SCP Command**:
   ```shell
   scp -i /path/to/private/key /path/to/local/application opc@132.145.209.168:/path/to/remote/directory
   ```

### Step 5: Set Up Gunicorn to Serve the Flask Application

1. **Install and Configure Gunicorn**:
   - Use pip to install Gunicorn.
   - Create a Gunicorn config file.

### Step 6: (Optional) Set Up a Reverse Proxy Server like Nginx

1. **Install and Configure Nginx**:
   - Install Nginx for advanced features like SSL and load balancing.

## Next Steps

- Utilize Terraform for ongoing infrastructure management.
- Regularly update your software and dependencies.
- Monitor and scale your instance as needed.

---
