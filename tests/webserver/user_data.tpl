#!/bin/bash -v

# Dependencies for ansible pull.
sudo apt-get update -y
sudo apt-get install git -y
sudo apt-get install ansible -y

# Run ansible pull.
sudo bash -c 'echo localhost > /etc/ansible/hosts'
sudo ansible-pull --url=${ app_repo } \
  --checkout=${ app_checkout } \
  --directory=/var/app ${ app_playbook } \
  --extra-vars "db_address=${ db_address } db_pass=${ db_pass }"
