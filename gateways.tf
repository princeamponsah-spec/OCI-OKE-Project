# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.display_name_prefix}-igw"
  enabled        = true
  freeform_tags  = var.tags
}

# NAT Gateway
resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.display_name_prefix}-nat"
  freeform_tags  = var.tags
}

#############################################
# OCI SERVICES LIST
#############################################
data "oci_core_services" "services" {}

#############################################
# OBJECT STORAGE SERVICE (correct match)
#############################################
locals {
  object_storage_service = one([
    for s in data.oci_core_services.services.services : s.id
    if s.name == "OCI LHR Object Storage"
  ])
}

#############################################
# SERVICE GATEWAY
#############################################
resource "oci_core_service_gateway" "sgw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.display_name_prefix}-svcgw"

  services {
    service_id = local.object_storage_service
  }

  freeform_tags = var.tags
}
