#!/bin/bash

yum update -y
yum install -y docker awscli

systemctl enable docker
systemctl start docker

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 536376965240.dkr.ecr.eu-west-2.amazonaws.com

CONTAINER_IMAGE=$(aws ssm get-parameter \
  --name "/production-cloud-platform/dev/container-image" \
  --query "Parameter.Value" \
  --output text \
  --region eu-west-2)

docker pull "$CONTAINER_IMAGE"

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
  "$CONTAINER_IMAGE"
  