### [Server] ###

variable "count" { default = 1 }
variable "private_key_path" { default = "~/workshop/workshop" }
variable "windows_password" { default = "MyTempPasswd!23"}

variable "linux_user_data" {
  type = "string"
  default = <<EOF
#cloud-config
system_info:
  default_user:
    name: demo
package_update: true
package_upgrade: true
package_reboot_if_required: true
packages:
  - curl
  - git
  - ntp
  - ntpdate
EOF
}
variable "windows_user_data" {
  type = "string"
  default = <<EOF
#ps1
net user Administrator MyTempPasswd!23
EOF
}

## Linux
resource "openstack_compute_instance_v2" "linux" {
  name = "workshop-linux${count.index+1}"
  count = "${var.count}"
  image_name = "ubuntu-16.04.2-server-20170614"
  flavor_name = "m1.tiny"
  network = {
    uuid = "${openstack_networking_network_v2.workshop_net.id}"
  }
  key_pair = "${openstack_compute_keypair_v2.workshop_key.name}"
  security_groups = ["${openstack_compute_secgroup_v2.workshop_ssh_provider.name}"]
  user_data = "${var.linux_user_data}"
}

resource "openstack_networking_floatingip_v2" "linux_fip" {
  count = "${var.count}"
  pool = "ext-net-01"
}

resource "openstack_compute_floatingip_associate_v2" "linux_fip" {
  count = "${var.count}"
  floating_ip = "${element(openstack_networking_floatingip_v2.linux_fip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.linux.*.id, count.index)}"
  provisioner "remote-exec" {
    inline = ["uname -a"]
    connection {
      host = "${element(openstack_networking_floatingip_v2.linux_fip.*.address, count.index)}"
      user = "demo"
      private_key = "${file(var.private_key_path)}"
      timeout = "20m"
    }
  }
}

output "workshop_linux_hosts" {
  value = "${join(",", openstack_networking_floatingip_v2.linux_fip.*.floating_ip)}"
}

## Windows
resource "openstack_compute_instance_v2" "windows" {
  count = "${var.count}"
  flavor_name = "w1.small"
  image_name = "windows-server-2016-desktop-20170614"
  key_pair = "${openstack_compute_keypair_v2.workshop_key.name}"
  name = "workshop-windows${count.index+1}"
  network = { 
    uuid = "${openstack_networking_network_v2.workshop_net.id}"
  }
  security_groups = ["${openstack_compute_secgroup_v2.workshop_winrm_provider.name}"]
  user_data = "${var.windows_user_data}"
}

resource "openstack_networking_floatingip_v2" "windows_fip" {
  count = "${var.count}"
  pool = "ext-net-01"
}

resource "openstack_compute_floatingip_associate_v2" "windows_fip" {
  count = "${var.count}"
  floating_ip = "${element(openstack_networking_floatingip_v2.windows_fip.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.windows.*.id, count.index)}"
  provisioner "remote-exec" {
    inline = ["powershell.exe -Command Write-Host \"Hello world!\""]
    connection {
      host = "${element(openstack_networking_floatingip_v2.windows_fip.*.address, count.index)}"
      https = true
      insecure = true
      user = "Administrator"
      password = "${var.windows_password}"
      port = 5986
      timeout = "20m"
      type = "winrm"
    }
  }
}

output "workshop_windows_hosts" {
  value = "${join(",", openstack_networking_floatingip_v2.windows_fip.*.floating_ip)}"
}
