# Terraform Scripts for Development Environment

These terraform scripts are designed to allow development environments to be easily created for the purposes of remote - low-bandwidth work.

# Setup

When creating a service account for the terraform jobs, grant it the `Security Admin` permission.

`.creds` folder should include a copy of the GCP service account credentials for this to work.

Create an image for the jumpbox by changing the ssh port on an instance to 65432 and make an image from that disk, and name that image `jmpbx`.

`make setup-gcp-network` will create the permissions required for the environment.

`make add-oslogin-key` adds your oslogin key to allow ssh access.

`make ingress-on` / `off` bring up and down both the internal firewall that allows access between machines, and the external ip exposure to the web, and the jumpbox.

`make ssh` starts an ssh session to the jumpbox.

# TODO

* Write a terraform script for making a generic devbox that uses an image with the repo as an argument
* Make it easy to create a new disk image for use as a development environment
* Make ssh work to target internal IP from vscode SSH extension
