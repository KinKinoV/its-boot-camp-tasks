#!/bin/bash
# Installing Docker
sudo yum update
sudo yum -y install docker
sudo usermod -a -G docker ec2-user
id ec2-user
newgrp docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
docker run -p 80:3000 ghcr.io/benc-uk/nodejs-demoapp:latest
