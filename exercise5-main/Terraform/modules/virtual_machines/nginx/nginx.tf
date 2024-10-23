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


resource "openstack_compute_instance_v2" "nginx" {
  name            = "nginx-vm"
  image_name      = "centos_image2"
  flavor_name     = "medium-server"
  key_pair        = "my-keypair"
  security_groups = ["default"]

  user_data = <<-EOF
    #cloud-config
    packages:
      - docker-ce
      - docker-ce-cli

    ssh_authorized_keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMDMUSG95vyDpsGegIPaBOVIqESvM4zvbyRUBCAIMcHJ simpsekundaer@gmail.com

    runcmd:
      - sudo dnf update -y
      - sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
      - sudo dnf install docker-ce docker-ce-cli containerd.io -y
      - sudo systemctl start docker
      - sudo docker version
      - touch /etc/docker/daemon.json
      - echo '{"mtu" ':' 1442}' | sudo tee /etc/docker/daemon.json
      - sudo systemctl restart docker.service
      - docker network inspect bridge
      - docker --version

  EOF

  network {
    name = "Group_20_network"
  }
}


resource "openstack_networking_floatingip_v2" "nginx_floating_ip" {
  pool = "provider"
}

resource "openstack_compute_floatingip_associate_v2" "nginx_floating_ip_association" {
  floating_ip = openstack_networking_floatingip_v2.nginx_floating_ip.address
  instance_id = openstack_compute_instance_v2.nginx.id
}

