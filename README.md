# Terraform & Packer Demo/Workshop
Prereqs:
- `source openrc.sh` so Terraform/Packer can communicate with OpenStack.
- Create `terraform` directory in Swift if you want to use it as a backend for terraform state. Otherwise remove `terraform {}` block in `terraform/variables.tf`.
- Replace `TF_VAR_private_key_path` inside `openrc.sh` with working directory.

## Terraform
`cd terraform; terraform apply`

You can use `terraform plan` to see what Terraform will do. Use `terraform destroy` to start over.

TODO(holmsten): Remote exec for windows instance fails on first run when refering to security group ID, name works. Canceling when there's only Windows remote exec step leftUsing ID is much better as there can be multiple security groups with same name. Possible terraform bug?

## Packer
`cd packer; packer build windows.json`

To run Packer successfully you have to download PSWindowsUpdate from TechNet manually due to license not permitting redistribution. You can download it from https://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc. Place the file inside packer directory.

From terraform run output, copy the workshop_net_id value shown and input it in `"networks": []` list in `packer/windows.json` file.
