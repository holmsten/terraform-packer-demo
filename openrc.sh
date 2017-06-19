#!/bin/bash
#
# Run this before running terraform commands
#

echo "OpenStack username: "
read -r OS_USERNAME_INPUT
export OS_USERNAME=$OS_USERNAME_INPUT
export TF_VAR_os_username=$OS_USERNAME_INPUT

echo "OpenStack tenant name: "
read -r OS_TENANT_INPUT
export OS_TENANT_NAME=$OS_TENANT_INPUT
export OS_PROJECT_NAME=$OS_TENANT_INPUT
export TF_VAR_os_tenant_name=$OS_TENANT_INPUT

echo "OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT
export TF_VAR_os_password=$OS_PASSWORD_INPUT

export OS_AUTH_URL="https://ops.elastx.net:5000/v2.0"
export TF_VAR_auth_url="$OS_AUTH_URL"

export TF_VAR_private_key_path="~/terraform-packer-demo/workshop"
export TF_VAR_public_key_path="~/terraform-packer-demo/workshop.pub"

