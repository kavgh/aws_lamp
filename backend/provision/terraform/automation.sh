#!/usr/bin/sh

terraform apply -auto-approve
terraform output -no-color > ../packer/variables.auto.pkrvars.hcl
sed -i "/db_username/s/<sensitive>/`terraform output db_username`/; /db_endpoint/s/:3306//; /db_password/s/<sensitive>/`terraform output db_password`/" ../packer/variables.auto.pkrvars.hcl
cd ../packer/
sleep 30
packer build .
cd -
terraform destroy -auto-approve