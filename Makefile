add-oslogin-key:
	gcloud compute os-login ssh-keys add --key-file ~/.ssh/google_compute_engine.pub

ssh:
	ssh-keygen -f "/home/tom/.ssh/known_hosts" -R "[$$(terraform output jmpbx_ip)]:65432"
	ssh $$(terraform output ssh_user)@$$(terraform output jmpbx_ip) -p 65432 -oStrictHostKeyChecking=no -A

show:
	cd devbox && terraform show
	cd jumpbox && terraform show
	cd setup && terraform show

devb:
	ssh -F ssh_config devbox
