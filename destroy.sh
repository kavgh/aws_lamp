#!/usr/bin/sh

## Destroy frontend
cd backend
vpc_id=$(terraform output vpc_id)
subnet_ids=$(terraform output public_subnet_ids)
sns_arn=$(terraform output sns_arn)
ec2_sg_id=$(terraform output ssh_sg_id)
out_sg_id=$(terraform output out_sg_id)
lb_sg_id=$(terraform output http_sg_id)
cd ../frontend
terraform destroy -var "vpc_id=$vpc_id" -var "public_subnet_ids=$subnet_ids" -var "sns_topic_arn=$sns_arn" -var "ec2_sg_ids=[$ec2_sg_id, $out_sg_id]" -auto-approve
cd -

## Destroy backend
terraform destroy -var "db_snapshot_id=$(cat ./db_snapshot_id)" -auto-approve
exit 0