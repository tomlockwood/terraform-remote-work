ingress-on:
	cd jumpbox && terraform apply -var-file="../terraform.tfvars" -auto-approve

ingress-off:
	cd jumpbox && terraform destroy -var-file="../terraform.tfvars" -auto-approve

setup-gcp-network:
	terraform apply setup -auto-approve

add-oslogin-key:
	gcloud compute os-login ssh-keys add --key-file ~/.ssh/google_compute_engine.pub

ssh:
	ssh-keygen -f "/home/tom/.ssh/known_hosts" -R "[$$(terraform output jmpbx_ip)]:65432"
	ssh $$(terraform output ssh_user)@$$(terraform output jmpbx_ip) -p 65432 -oStrictHostKeyChecking=no -A
