# main.tf
# Very small root file to orchestrate (you already have provider.tf).
# This file can be empty or used to call modules. For this scaffold we just depend on the resources across the files.
terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 4.0"
    }
  }
}

# (Optional) locals or additional configuration
locals {
  prefix = var.cluster_name
}
