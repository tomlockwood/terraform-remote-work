#!/bin/sh

# Outputs an export statement for each key in a terraform json outputs file
json_cat() {
  local f="$1"
  cat $f | jq -r 'keys[] as $k | "export TF_VAR_\($k)=\"\(.[$k] | .value)\"" '
}

for file in ./*_outputs.json; do
  eval $( json_cat $file )
done

cd $1
terraform init
terraform $2 -var-file="../terraform.tfvars" $3
cd ..
terraform output -json -state=$1/terraform.tfstate > $1_outputs.json
