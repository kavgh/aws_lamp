#!/bin/bash

sudo apt-get update && sudo apt-get install mysql-client -y #curl unzip gpg 

#curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
#curl -o /tmp/awscliv2.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig
#gpg --import /tmp/aws.gpg
#gpg --verify /tmp/awscliv2.sig /tmp/awscliv2.zip
#unzip /tmp/awscliv2.zip -d /tmp/
#sudo /tmp/aws/install

#RDS_TOKEN=`aws rds generate-db-auth-token --hostname $DB_ENDPOINT --port $DB_PORT --username $DB_USERNAME --region $REGION`

mysql --version
mysql -h $DB_ENDPOINT -u $DB_USERNAME -P $DB_PORT --password=$DB_PASSWORD $DB_NAME < $DB_BACKUP