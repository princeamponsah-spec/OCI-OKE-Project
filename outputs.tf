# outputs.tf

output "vcn_id" {
  description = "VCN OCID"
  value       = oci_core_virtual_network.vcn.id
}

output "public_subnet_id" {
  description = "Public subnet OCID"
  value       = oci_core_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "Private subnet OCID"
  value       = oci_core_subnet.private_subnet.id
}

output "bastion_instance_id" {
  description = "Bastion compute instance OCID"
  value       = oci_core_instance.bastion.id
}

# output "oke_cluster_id" {
#   description = "OKE cluster OCID"
#   value       = oci_containerengine_cluster.oke_cluster.id
# }

output "oke_cluster_id" {
  value = oci_containerengine_cluster.oke_cluster.id
}

output "oke_node_pool_id" {
  description = "OKE node pool OCID"
  value       = oci_containerengine_node_pool.node_pool.id
}
