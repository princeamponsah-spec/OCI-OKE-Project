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




