# oke.tf
resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = var.compartment_ocid
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vcn_id             = oci_core_virtual_network.vcn.id

  options {
    service_lb_subnet_ids = [oci_core_subnet.public_subnet.id]
  }

  freeform_tags = var.tags
}

# Get ALL Oracle Linux 8 images for your compartment
data "oci_core_images" "all_ol8_images" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = var.node_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"

  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
}

# Output to debug what images are found
output "debug_images_found" {
  value = length(data.oci_core_images.all_ol8_images.images)
}

output "debug_first_image" {
  value = length(data.oci_core_images.all_ol8_images.images) > 0 ? data.oci_core_images.all_ol8_images.images[0].display_name : "No images found"
}

resource "oci_containerengine_node_pool" "node_pool" {
  compartment_id     = var.compartment_ocid
  cluster_id         = oci_containerengine_cluster.oke_cluster.id
  name               = "${var.display_name_prefix}-nodepool"
  kubernetes_version = var.kubernetes_version
  node_shape         = var.node_shape

  node_shape_config {
    ocpus         = var.node_pool_ocpus != null ? var.node_pool_ocpus : 1
    memory_in_gbs = var.node_pool_memory_gbs != null ? var.node_pool_memory_gbs : 16
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = data.oci_core_images.all_ol8_images.images[0].id
    boot_volume_size_in_gbs = 50
  }

  node_config_details {
    size = var.node_pool_size

    placement_configs {
      availability_domain = var.availability_domain != "" ? var.availability_domain : null
      subnet_id           = oci_core_subnet.private_subnet.id
    }
  }

  freeform_tags = var.tags
}
