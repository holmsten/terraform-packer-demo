### [Security Groups ] ###
resource "openstack_compute_secgroup_v2" "workshop_ssh_provider" {
  name = "workshop-ssh-provider"
  description = "Members In This SG Provides Traffic on Port 22"
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    from_group_id = "${openstack_compute_secgroup_v2.workshop_ssh_consumer.id}"
  }
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "${var.net_cidr}"
  }
  rule {
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr = "${openstack_networking_subnet_v2.workshop_subnet.cidr}"
  }
}

resource "openstack_compute_secgroup_v2" "workshop_ssh_consumer" {
  name = "workshop-ssh-consumer"
  description = "Members In This SG can consume SSH services"
}

resource "openstack_compute_secgroup_v2" "workshop_winrm_consumer" {
  name = "workshop-winrm-consumer"
  description = "Members In This SG can consume WinRM services"
}

resource "openstack_compute_secgroup_v2" "workshop_winrm_provider" {
  name = "workshop-winrm-provider"
  description = "Members In This SG Provides Traffic on Port 5986"
  rule {
    from_port = 5986
    to_port = 5986
    ip_protocol = "tcp"
    from_group_id = "${openstack_compute_secgroup_v2.workshop_winrm_consumer.id}"
  }
  rule {
    from_port = 5986
    to_port = 5986
    ip_protocol = "tcp"
    cidr = "${var.net_cidr}"
  }
  rule {
    from_port = 5986
    to_port = 5986
    ip_protocol = "tcp"
    cidr = "${openstack_networking_subnet_v2.workshop_subnet.cidr}"
  }
}

output "workshop_secgroup_ssh_consumer_id" { value = "${openstack_compute_secgroup_v2.workshop_ssh_consumer.id}" }
output "workshop_secgroup_ssh_provider_id" { value = "${openstack_compute_secgroup_v2.workshop_ssh_provider.id}" }
output "workshop_secgroup_winrm_consumer_id" { value = "${openstack_compute_secgroup_v2.workshop_winrm_consumer.id}" }
output "workshop_secgroup_winrm_provider_id" { value = "${openstack_compute_secgroup_v2.workshop_winrm_provider.id}" }
