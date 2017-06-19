#!/usr/bin/env bash

if [ -f "terraform.tfstate" ]; then
   echo "Aborting tests. Detected existing terraform state, please run 'terraform destroy' and then remove the terraform.* files."
   exit
fi

terraform apply -var-file ./tests/spec/test.tfvar

echo "Wait 2 minutes to allow an ASG instance to come up."
sleep 120
terraform apply -var-file ./tests/spec/test.tfvar

cd tests
bundle exec rake spec
cd ..

terraform destroy -force && rm terraform.*

