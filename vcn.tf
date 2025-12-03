# vcn.tf
resource "oci_core_virtual_network" "vcn" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.display_name_prefix}-vcn"
  cidr_block     = var.vcn_cidr
  dns_label      = "${substr(var.display_name_prefix, 0, 6)}vcn"
  freeform_tags  = var.tags
}
