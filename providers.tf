provider "oci" {
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaatxtnrgi5akiqi6ywxsobrews24knrqapn6k6x6vzyfv2in3yyrua"
  user_ocid        = "ocid1.user.oc1..aaaaaaaaekysfju4q6uxc3x4uxk4vvicgsgdp5okz3ix2musjsv4e35iwe4a"
  fingerprint      = "9e:97:b3:f4:2a:45:c0:17:5b:fb:22:e1:db:4d:97:17"
  private_key_path = "/Users/prince/.oci/oci_terraform_key_unencrypted.pem"
  region           = "uk-london-1"
}

// backend.tf
terraform {
  required_version = ">= 1.3.0"
  backend "oci" {
    bucket           = "bucket-kowri-1305"
    namespace        = "lr7o4f7vwvt0"
    region           = "uk-london-1"                                                                     # or hardcode like "us-ashburn-1"
    tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaatxtnrgi5akiqi6ywxsobrews24knrqapn6k6x6vzyfv2in3yyrua" # optional, but recommended
    user_ocid        = "ocid1.user.oc1..aaaaaaaaekysfju4q6uxc3x4uxk4vvicgsgdp5okz3ix2musjsv4e35iwe4a"    # optional
    fingerprint      = "9e:97:b3:f4:2a:45:c0:17:5b:fb:22:e1:db:4d:97:17"                                 # optional
    private_key_path = "/Users/prince/.oci/oci_terraform_key_unencrypted.pem"                            # optional
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
