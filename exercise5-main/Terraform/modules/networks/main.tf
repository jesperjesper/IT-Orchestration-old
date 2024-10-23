terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "1.51.1"
    }
  }
}

provider "openstack" {
  user_name            = "group_20_ikt114"
  password             = "258f81b3c1a44b6ab817171d106c2f07"
  auth_url             = "http://kaun.uia.no:5000/v3"
  project_domain_name  = "IT_ORKESTRERING"
  user_domain_name     = "IT_ORKESTRERING"
}

resource "openstack_networking_network_v2" "Group_20_network"{
  name           = "Group_20_network"
  admin_state_up = "true"
}


resource "openstack_networking_subnet_v2" "Group_20_subnet" {
  name       = "Group_20_subnet"
  cidr       = "192.168.1.0/24"
  ip_version = 4
  network_id = openstack_networking_network_v2.Group_20_network.id

  dns_nameservers = [
    "158.37.218.20",
    "158.37.218.21",
    "158.37.242.20",
    "158.37.242.21",
    "128.39.54.10",
  ]

  gateway_ip = "192.168.1.1"
}

resource "openstack_networking_router_v2" "Group_20_Router" {
  name           = "Group_20_router"
  admin_state_up = true
  external_network_id = "9992655d-0892-4fe0-8a62-d9dac9044be2"
}

resource "openstack_networking_router_interface_v2" "Group_20_Router_iface" {
  router_id = openstack_networking_router_v2.Group_20_Router.id
  subnet_id = openstack_networking_subnet_v2.Group_20_subnet.id
}


resource "openstack_compute_keypair_v2" "my-keypair" {
  name = "my-keypair"
  public_key =  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDG+763sPbJ48oOqvOpZ8kc1B9q8WG17ZU1YG0C6/Z1rBCAi/i1Z9hnxUJU73WlL/gOkskTfkNI5YLX0U/+bjdHPd/kj36QQsR2JwQ2yXgxqT3iaFSaEHeqGthy8yfMtBc92SPdyhUGqa9kPHA/EXcnjKZD8sIjeImVddtRMzzPmAJNc4k5BR4PCFzYKBFRO5PNklrN3x4agjFRdjJPiYAYq7Yp4Zaq7kMhk4GnVy/T8ybMA/XQ9IWlDH0TclHtNuRlag1G1Z2HYUFBu2HRKZu8e6yo572eo9fT4fbshhRfASSfvKFPPdkj3wwf8m5vYUUoqeotZ+UjrbmtDAMl1Y62NcPRapOPQMEFM/JXRbuuaptDrLYFPRcOdsjS3xXbEw+c5TK++E8BaG2dneEsmVhXTg8jcAwlxtyC1yGCpd1PvHF/c50aLJF92cMBnnMFFG9FJN/gVV1lYLUtfUwKdrm3qEiEERcr6k3Xy9UmT1UQLcnN8I4lQae5Fw9uyfKcYv86lI/bUC7mkRO+nKIk4FkjXeeOvQXmPc+45CPePpm+KOPHf1wq6lVfknXD6Y8770WXZUP/Ns3lm8f5xaNKyg2Rkpi4T+vgD5QZpxwe+LT1zB+vaUAbahR84FjYJY7sGaXWMGO565rImv34PgB9JAH8mpvObfuVXCxnz5aoPfY2jQ== jespereh@ikt114-g-23v-jespereh"
}




