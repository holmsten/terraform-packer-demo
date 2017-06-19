# These variables are received through ENV variables created
# by terraform-openrc.sh. Run that first.

variable "os_password" {}
variable "os_username" {}
variable "os_tenant_name" {}
variable "net_cidr" {
  default = "0.0.0.0/0"
}

### [Elastx Openstack] ###
provider "openstack" {
  user_name = "${var.os_username}"
  tenant_name = "${var.os_tenant_name}"
  password = "${var.os_password}"
}

### [Data Backend] ###
terraform {
  backend "swift" {
    path = "terraform/workshop"
  }
}

