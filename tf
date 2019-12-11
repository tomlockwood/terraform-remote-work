#!/bin/sh

for file in ./*_outputs.json; do
  eval $( cat $file )
done
cd $1
terraform init
terraform $2 -var-file="../terraform.tfvars" $3
cd ..
terraform output -json -state=$1/terraform.tfstate | jq -r 'keys[] as $k | "export TF_VAR_\($k)=\"\(.[$k] | .value)\"" ' > $1_outputs.json
