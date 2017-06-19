#!/usr/bin/env bash

# An identifier to name AWS resources with.
#IDENT=$1

if [ -f "terraform.tfstate" ]; then
   echo "Aborting tests. Detected existing terraform state, please run 'terraform destroy' and then remove the terraform.* files."
   #exit
fi

#if [ -z "$IDENT" ]; then
   # echo "Please pass a string identifier to avoid resource name collisions."
   # exit
#fi


PUBLIC_KEY=`cat ./tests/specs/insecure_key.pub`

# terraform plan -var 'identifier='"${IDENT}"
#terraform apply -var 'remote_key='"${PUBLIC_KEY}"

cd tests
bundle exec rake spec
cd ..


# terraform destroy -force
