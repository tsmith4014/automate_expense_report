#main.tf
# less /var/log/cloud-init.log
# less /var/log/cloud-init-output.log

#testing adding a internet gateway
# main.tf

resource "oci_core_vcn" "test_vcn" {
  compartment_id = var.compartment_id
  display_name   = "test_vcn"
  cidr_block     = "10.0.0.0/16"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_core_subnet" "test_subnet" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  vcn_id              = oci_core_vcn.test_vcn.id
  display_name        = "test_subnet"
  cidr_block          = "10.0.1.0/24"
  # route_table_id      = oci_core_vcn.test_vcn.default_route_table_id
  route_table_id    = oci_core_route_table.test_rt.id
  dhcp_options_id   = oci_core_vcn.test_vcn.default_dhcp_options_id
  security_list_ids = [oci_core_security_list.test_sl.id]
  # security_list_ids = [oci_core_vcn.test_vcn.default_security_list_id]
}

resource "oci_core_instance" "test_instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = "test_instance"
  shape               = "VM.Standard.E2.1.Micro"

  create_vnic_details {
    subnet_id = oci_core_subnet.test_subnet.id
  }

  source_details {
    source_type = "image"
    source_id   = var.source_id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
    user_data           = base64encode(file("${path.module}/user_data.sh"))
  }
}

resource "oci_core_internet_gateway" "test_ig" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "test_ig"
  enabled        = true
}

resource "oci_core_route_table" "test_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "test_rt"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.test_ig.id
  }
}

resource "oci_core_security_list" "test_sl" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "test_sl"

  ingress_security_rules {
    protocol = "6" # TCP protocol
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6" # TCP protocol
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol = "6" # TCP protocol
    source   = "0.0.0.0/0"
    tcp_options {
      min = 8000
      max = 8000
    }
  }
}






# #works with .env file
# resource "oci_core_vcn" "test_vcn" {
#   compartment_id = var.compartment_id
#   display_name   = "test_vcn"
#   cidr_block     = "10.0.0.0/16"
# }

# data "oci_identity_availability_domains" "ads" {
#   compartment_id = var.compartment_id
# }

# resource "oci_core_subnet" "test_subnet" {
#   availability_domain = var.availability_domain
#   compartment_id      = var.compartment_id
#   vcn_id              = oci_core_vcn.test_vcn.id
#   display_name        = "test_subnet"
#   cidr_block          = "10.0.1.0/24"
#   route_table_id      = oci_core_vcn.test_vcn.default_route_table_id
#   dhcp_options_id     = oci_core_vcn.test_vcn.default_dhcp_options_id
#   security_list_ids   = [oci_core_vcn.test_vcn.default_security_list_id]
# }

# resource "oci_core_instance" "test_instance" {
#   availability_domain = var.availability_domain
#   compartment_id      = var.compartment_id
#   display_name        = "test_instance"
#   shape               = "VM.Standard.E2.1.Micro"

#   create_vnic_details {
#     subnet_id = oci_core_subnet.test_subnet.id
#   }

#   source_details {
#     source_type = "image"
#     source_id   = var.source_id
#   }

#   metadata = {
#     ssh_authorized_keys = file(var.ssh_public_key)
#     user_data           = base64encode(file("${path.module}/user_data.sh"))
#   }
# }


#below works but has hard coded values, above is the same code but with variables
# # main.tf this code works to create a vcn but not a subnet
# resource "oci_core_vcn" "test_vcn" {
#   compartment_id = "ocid1.tenancy.oc1..aaaaaaaano3cnn6crdwfob4an6zeikeqthkehtkty2sxlk5kydeep6wrwcsq"
#   display_name   = "test_vcn"
#   cidr_block     = "10.0.0.0/16"
# }


# # this code creates the subnet for the vcn created in the Code above

# data "oci_identity_availability_domains" "ads" {
#   compartment_id = "ocid1.tenancy.oc1..aaaaaaaano3cnn6crdwfob4an6zeikeqthkehtkty2sxlk5kydeep6wrwcsq"
# }

# resource "oci_core_subnet" "test_subnet" {
#   availability_domain = "SbxO:US-ASHBURN-AD-2"
#   compartment_id      = "ocid1.tenancy.oc1..aaaaaaaano3cnn6crdwfob4an6zeikeqthkehtkty2sxlk5kydeep6wrwcsq"
#   vcn_id              = oci_core_vcn.test_vcn.id
#   display_name        = "test_subnet"
#   cidr_block          = "10.0.1.0/24"
#   route_table_id      = oci_core_vcn.test_vcn.default_route_table_id
#   dhcp_options_id     = oci_core_vcn.test_vcn.default_dhcp_options_id
#   security_list_ids   = [oci_core_vcn.test_vcn.default_security_list_id]
# }


# resource "oci_core_instance" "test_instance" {
#   availability_domain = "SbxO:US-ASHBURN-AD-2"
#   compartment_id      = "ocid1.tenancy.oc1..aaaaaaaano3cnn6crdwfob4an6zeikeqthkehtkty2sxlk5kydeep6wrwcsq"
#   display_name        = "test_instance"
#   shape               = "VM.Standard.E2.1.Micro"

#   create_vnic_details {
#     subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaahien33p5rd74j4mcvqhreikqc7kilishob6ge234k6tj2zirzqbq"
#   }

#   source_details {
#     source_type = "image"
#     source_id   = "ocid1.image.oc1.iad.aaaaaaaaszr5wpipg6qskiol3fhbitm56qdmumpbcpv6irzxuofi2nfmlhma"
#   }
# }
