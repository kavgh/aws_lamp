#!/usr/bin/sh

## Provision database
pushd backend/provision/terraform
./automation.sh
popd

## Deploy backend
cd backend
echo -n "Enter RDS snapshot name that was created: "
read db_snapshot_id
echo "$db_snapshot_id" > ./db_snapshot_id

terraform apply -var "db_snapshot_id=$(cat ./db_snapshot_id)" -auto-approve
vpc_id=$(terraform output vpc_id)
sns_arn=$(terraform output sns_arn)
subnet_ids=$(terraform output public_subnet_ids)
ec2_sg_id=$(terraform output ssh_sg_id)
out_sg_id=$(terraform output out_sg_id)
lb_sg_id=$(terraform output http_sg_id)
sed -i "/jdbc.url/s/\(.*\/\/\).*\(\/.*\)/\1$(terraform output -raw rds_endpoint)\2/; /memcached.active.host/s/=.*/=$(terraform output -raw mc_address)/; /memcached.active.port/s/=[0-9]*/=$(terraform output -raw mc_port)/; /rabbitmq.username/s/=.*/=$(terraform output -raw rmq_username)/; /rabbitmq.password/s/=.*/=$(terraform output -raw rmq_password)/; /rabbitmq.address/s/=.*/=$(terraform output -raw rmq_endpoint | cut -d "/" -f3 | cut -d ":" -f1)/; /rabbitmq.port/s/=[0-9]*/=$(terraform output -raw rmq_endpoint | cut -d ":" -f3)/" ~/Projects/resources/vprofile-project/src/main/resources/application.properties
cd provision/packer
sed -i "/jdbc.username/s/=.*/=$(sed -n "/db_username/p" variables.auto.pkrvars.hcl | cut -d '"' -f2)/; /jdbc.password/s/=.*/=$(sed -n "/db_password/p" variables.auto.pkrvars.hcl | cut -d '"' -f2)/" ~/Projects/resources/vprofile-project/src/main/resources/application.properties
cd ~/Projects/resources/vprofile-project
mvn install

## Deploy frontend
cd -
cd ../../../frontend
mv ~/Projects/resources/vprofile-project/target/*.war ./modules/s3/resources/ROOT.war
terraform apply -var "vpc_id=$vpc_id" -var "public_subnet_ids=$subnet_ids" -var "sns_topic_arn=$sns_arn" -var "ec2_sg_ids=[$ec2_sg_id, $out_sg_id]" -var "elb_sg_ids=[$lb_sg_id]" -auto-approve
exit 0