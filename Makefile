oslogin:
	gcloud compute os-login ssh-keys add --key-file ~/.ssh/google_compute_engine.pub

ssh-jmpbx:
	ssh $$(terraform output ssh_user)@$$(terraform output jmpbx_ip) -p 65432 -oStrictHostKeyChecking=no -A

# TODO: test this next time infra is up 
taint-ip:
	terraform taint "google_compute_firewall.external-jumpbox-allow-ssh"
