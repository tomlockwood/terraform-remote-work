add-oslogin-key:
	gcloud compute os-login ssh-keys add --key-file ~/.ssh/google_compute_engine.pub

show:
	cd devbox && terraform show
	cd jumpbox && terraform show
	cd setup && terraform show
