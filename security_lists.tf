# security_lists.tf

# PUBLIC security list - for control plane and load balancers
resource "oci_core_security_list" "public_sec_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.display_name_prefix}-public-slist"

  # ==================== INGRESS RULES ====================

  # Allow Kubernetes API (6443) from worker nodes
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.2.0/24" # Private subnet (worker nodes)
    tcp_options {
      min = 6443
      max = 6443
    }
    description = "Kubernetes API from worker nodes"
  }

  # Allow worker node registration (12250)
  ingress_security_rules {
    protocol = "6"
    source   = "10.0.2.0/24" # Private subnet (worker nodes)
    tcp_options {
      min = 12250
      max = 12250
    }
    description = "Worker node registration"
  }

  # Allow SSH from anywhere (restrict in production!)
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      max = 22
      min = 22
    }
    description = "SSH from anywhere (change to restricted CIDR!)"
  }

  # Allow HTTP
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
    description = "HTTP"
  }

  # Allow HTTPS
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
    description = "HTTPS"
  }

  # Path MTU Discovery
  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "10.0.2.0/24"
    icmp_options {
      type = 3
      code = 4
    }
    description = "Path MTU Discovery from worker nodes"
  }

  # ==================== EGRESS RULES ====================

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all egress"
  }

  freeform_tags = var.tags
}

# BASTION security list
resource "oci_core_security_list" "bastion_sec_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.display_name_prefix}-bastion-slist"

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0" # REPLACE with your office/home IP for security
    tcp_options {
      min = 22
      max = 22
    }
    description = "SSH to bastion (restrict this CIDR in production)"
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  freeform_tags = var.tags
}

# PRIVATE security list - worker nodes
resource "oci_core_security_list" "private_sec_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "${var.display_name_prefix}-private-slist"

  # ==================== INGRESS RULES ====================

  # Allow all traffic from within entire VCN
  ingress_security_rules {
    protocol    = "all"
    source      = var.vcn_cidr # 10.0.0.0/16
    source_type = "CIDR_BLOCK"
    stateless   = false
    description = "All traffic from within VCN"
  }

  # Allow SSH from bastion subnet
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = var.bastion_subnet_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
    description = "SSH from bastion"

    tcp_options {
      min = 22
      max = 22
    }
  }

  # Path MTU Discovery from anywhere
  ingress_security_rules {
    protocol    = "1" # ICMP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    description = "Path MTU Discovery"

    icmp_options {
      type = 3
      code = 4
    }
  }

  # ==================== EGRESS RULES ====================

  # 1. All traffic within VCN (covers all internal communication)
  egress_security_rules {
    protocol         = "all"
    destination      = var.vcn_cidr # 10.0.0.0/16
    destination_type = "CIDR_BLOCK"
    stateless        = false
    description      = "All traffic within VCN (includes pods and control plane)"
  }

  # 2. TCP to OKE control plane on port 6443 (Kubernetes API)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "10.0.0.0/28"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    description      = "TCP traffic to Kubernetes API server"

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # 3. TCP to OKE control plane on port 12250
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "10.0.0.0/28"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    description      = "TCP traffic to Kubelet"

    tcp_options {
      min = 12250
      max = 12250
    }
  }

  # 4. ICMP to OKE control plane types 3, 4
  egress_security_rules {
    protocol         = "1" # ICMP
    destination      = "10.0.0.0/28"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    description      = "ICMP traffic for path MTU discovery"

    icmp_options {
      type = 3
      code = 4
    }
  }

  # 5. TCP to Oracle Services on port 443 (Container Registry, Object Storage)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
    destination_type = "SERVICE_CIDR_BLOCK"
    stateless        = false
    description      = "TCP traffic to Oracle Services (Object Storage, Container Registry)"

    tcp_options {
      min = 443
      max = 443
    }
  }

  # 6. ICMP to internet types 3, 4
  egress_security_rules {
    protocol         = "1" # ICMP
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    description      = "ICMP traffic to internet"

    icmp_options {
      type = 3
      code = 4
    }
  }

  # 7. All protocols to internet (for pulling images, updates, etc.)
  egress_security_rules {
    protocol         = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    description      = "All traffic to internet via NAT Gateway"
  }

  freeform_tags = var.tags
}
