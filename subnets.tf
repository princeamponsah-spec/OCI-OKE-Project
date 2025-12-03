
resource "oci_core_subnet" "public_subnet" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.display_name_prefix}-public-subnet"
  # Remove availability_domain to make it regional
  vcn_id                     = oci_core_virtual_network.vcn.id
  cidr_block                 = var.public_subnet_cidr
  dns_label                  = "pubsub"
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.public_route_table.id
  security_list_ids          = [oci_core_security_list.public_sec_list.id]
  freeform_tags              = var.tags
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.display_name_prefix}-private-subnet"
  # Remove availability_domain to make it regional
  vcn_id                     = oci_core_virtual_network.vcn.id
  cidr_block                 = var.private_subnet_cidr
  dns_label                  = "privsub"
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.private_route_table.id
  security_list_ids          = [oci_core_security_list.private_sec_list.id]
  freeform_tags              = var.tags
}

resource "oci_core_subnet" "bastion_subnet" {
  compartment_id             = var.compartment_ocid
  display_name               = "${var.display_name_prefix}-bastion-subnet"
  availability_domain        = var.availability_domain != "" ? var.availability_domain : null
  vcn_id                     = oci_core_virtual_network.vcn.id
  cidr_block                 = var.bastion_subnet_cidr
  dns_label                  = "bastsub"
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.public_route_table.id
  security_list_ids          = [oci_core_security_list.bastion_sec_list.id]
  freeform_tags              = var.tags
}
