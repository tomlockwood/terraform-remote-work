oslogin:
	gcloud compute os-login ssh-keys add --key-file ~/.ssh/google_compute_engine.pub

ssh:
	ssh $$(terraform output ssh_user)@$$(terraform output jmpbx_ip) -p 65432 -oStrictHostKeyChecking=no
