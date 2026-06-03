#!/bin/bash

yum update -y
yum install -y docker awscli

systemctl enable docker
systemctl start docker

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 536376965240.dkr.ecr.eu-west-2.amazonaws.com

docker pull 536376965240.dkr.ecr.eu-west-2.amazonaws.com/production-cloud-platform-dev-app:dev-v2

docker rm -f banking-demo-api || true

docker run -d \
  --name banking-demo-api \
  --restart always \
  -p 8000:8000 \
  -e DB_HOST="${db_host}" \
  -e DB_PORT="${db_port}" \
  -e DB_NAME="${db_name}" \
  -e DB_USERNAME="${db_username}" \
  -e DB_PASSWORD="${db_password}" \
  536376965240.dkr.ecr.eu-west-2.amazonaws.com/production-cloud-platform-dev-app:dev-v2
  