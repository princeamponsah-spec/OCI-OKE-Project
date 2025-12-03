# variables.tf
terraform {
  required_version = ">= 1.0"
}

variable "compartment_ocid" {
  description = "OCID of the compartment where resources will be created"
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaatxtnrgi5akiqi6ywxsobrews24knrqapn6k6x6vzyfv2in3yyrua"
}

variable "tenancy_ocid" {
  description = "OCID of the tenancy (optional, sometimes useful)"
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaatxtnrgi5akiqi6ywxsobrews24knrqapn6k6x6vzyfv2in3yyrua"
}

variable "region" {
  description = "OCI region (optional if provider is already configured)"
  type        = string
  default     = "uk-london-1"
}

variable "display_name_prefix" {
  description = "Prefix used for display names for created resources"
  type        = string
  default     = "oke"
}

variable "vcn_cidr" {
  description = "CIDR for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet (nodes)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "bastion_subnet_cidr" {
  description = "CIDR for bastion host subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_domain" {
  description = "Availability Domain to place resources in (optional)"
  type        = string
  default     = "MDXt:UK-LONDON-1-AD-1"
}

variable "kubernetes_version" {
  description = "OKE K8s version (match available in your region)"
  type        = string
  default     = "v1.34.1" # change to a supported version in your region
}

variable "cluster_name" {
  description = "OKE cluster display name"
  type        = string
  default     = "oke-cluster"
}

variable "node_shape" {
  description = "Shape for worker nodes"
  type        = string
  default     = "VM.Standard.E3.Flex"
}

variable "node_image_id" {
  description = "OCID of the image to use for node pool instances (required)"
  type        = string
  default     = "ocid1.image.oc1.uk-london-1.aaaaaaaa7rzcdyvxcvam45xcr7wk5niy4m6lcdlqdevo2hjdmpwjgvoprtlq"
}

variable "node_image_name" {
  description = "Alternative: node image name (use if you prefer names over OCIDs)"
  type        = string
  default     = ""
}

variable "node_pool_size" {
  description = "Initial number of nodes in the node pool"
  type        = number
  default     = 2
}

variable "ssh_public_key" {
  description = "SSH public key used by node pool and bastion (ssh-rsa AAAA... user@host)"
  type        = string
  default     = "/Users/prince/.ssh/id_rsa.pub"
}

variable "tags" {
  description = "Freeform tags (map)"
  type        = map(string)
  default     = {}
}



variable "fingerprint" {
  description = "user key finger print"
  type        = string
  default     = "96:05:11:7b:20:24:d4:8b:3d:24:94:5e:69:1a:c2:25"
}
variable "private_key_path" {
  description = "Source routet to private ssh key"
  type        = string
  default     = "~/.oci/oci_api_key.pem"
}


# variables.tf

variable "node_pool_ocpus" {
  description = "Number of OCPUs per node (for flexible shapes)"
  type        = number
  default     = 1
}

variable "node_pool_memory_gbs" {
  description = "Memory in GBs per node (for flexible shapes)"
  type        = number
  default     = 16
}
