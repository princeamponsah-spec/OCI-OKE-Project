provider "oci" {
  tenancy_ocid     = ""
  user_ocid        = ""
  fingerprint      = ""
  private_key_path = ""
  region           = "uk-london-1"
}

// backend.tf
terraform {
  required_version = ">= 1.3.0"
  backend "oci" {
    bucket           = "" # State bucket for terraform state
    namespace        = ""
    region           = "uk-london-1" # or hardcode like "us-ashburn-1"
    tenancy_ocid     = ""            # optional, but recommended
    user_ocid        = ""            # optional
    fingerprint      = ""            # optional
    private_key_path = ""            # optional
    key              = "terraform.tfstate"
  }
}



# terraform {
#   required_version = ">= 1.2.0"

#   required_providers {
#     oci = {
#       source  = "hashicorp/oci"
#       version = ">= 7.0.0"
#     }
#   }
# }

# provider "oci" {
#   # Use env vars or shared config - supply profile/region here if needed.
#   tenancy_ocid     = var.tenancy_ocid
#   user_ocid        = var.user_ocid
#   fingerprint      = var.fingerprint
#   private_key_path = var.private_key_path
#   region           = var.region
# }
