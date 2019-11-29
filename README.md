# Terraform Scripts for Development Environment

These terraform scripts are designed to allow development environments to be easily created for the purposes of remote - low-bandwidth work.

`.creds` folder should include a copy of the GCP service account credentials for this to work.

# TODO

* Create a jumpbox and ssh via it into the cloud
* Make it easy to create a new container for use as a development environment
* Boot a development environment built to a repository's specifications, and then clone that repository into that environment
