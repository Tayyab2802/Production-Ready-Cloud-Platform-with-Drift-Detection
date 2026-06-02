#!/bin/bash

yum update -y
yum install -y docker awscli

systemctl enable docker
systemctl start docker

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 536376965240.dkr.ecr.eu-west-2.amazonaws.com

docker pull 536376965240.dkr.ecr.eu-west-2.amazonaws.com/production-cloud-platform-dev-app:dev-v1

docker run -d \
  --name banking-demo-api \
  --restart always \
  -p 8000:8000 \
  536376965240.dkr.ecr.eu-west-2.amazonaws.com/production-cloud-platform-dev-app:dev-v1