#!/bin/bash

#important to give time so EC2 is up and running.
sleep 30

sudo yum update -y

#install node and other services.

sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs

sudo yum install unzip -y
cd ~/ && unzip sample-nodeApp.zip
cd ~/sample-nodeApp && npm i --only=prod

sudo mv /tmp/sample-nodeApp.service /etc/systemd/system/sample-nodeApp.service
sudo systemctl enable sample-nodeApp.service
sudo systemctl start sample-nodeApp.service