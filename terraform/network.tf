### [Network] ###
resource "openstack_networking_network_v2" "workshop_net" {
  name = "workshop-net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "workshop_subnet" {
  name       = "workshop-subnet"
  network_id = "${openstack_networking_network_v2.workshop_net.id}"
  cidr       = "10.0.10.0/24"
  ip_version = 4
  enable_dhcp = "true"
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "openstack_networking_router_v2" "workshop_router" {
  name             = "workshop-router"
  external_gateway = "62954df1-05bb-42e5-9960-ca921cccaeeb"
}

resource "openstack_networking_router_interface_v2" "workshop_interface-1" {
  router_id = "${openstack_networking_router_v2.workshop_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.workshop_subnet.id}"
}

output "workshop_net_id" { value = "${openstack_networking_network_v2.workshop_net.id}" }
output "workshop_subnet_cidr" { value = "${openstack_networking_subnet_v2.workshop_subnet.cidr}" }
