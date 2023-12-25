#!/bin/bash
# shellcheck disable=SC2164
cd /home/ec2-user
sudo yum update -y
sudo yum install python3 python3-pip -y
git clone https://github.com/psinha87/python-mysql-db-proj-1.git
sleep 20
# shellcheck disable=SC2164
cd python-mysql-db-proj-1
pip3 install -r requirements.txt
echo 'Waiting for 30 seconds before running the app.py'
setsid python3 -u app.py &
sleep 30
