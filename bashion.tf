# bashion.tf
data "oci_core_images" "ubuntu_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E3.Flex" # Filter for compatible images
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "bastion" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain != "" ? var.availability_domain : null
  shape               = "VM.Standard.E3.Flex"
  display_name        = "${var.display_name_prefix}-bastion"

  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.bastion_subnet.id
    assign_public_ip = true
    hostname_label   = "bastion"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_images.images[0].id # Use the data source
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }

  freeform_tags = var.tags
}
