#!/bin/bash -v

# Dependencies for ansible pull.
sudo apt-get update -y
sudo apt-get install git -y
sudo apt-get install ansible -y

# Run ansible pull.
sudo bash -c 'echo localhost > /etc/ansible/hosts'
sudo ansible-pull --url=${ app_repo } --directory=/var/www ${ app_playbook }
