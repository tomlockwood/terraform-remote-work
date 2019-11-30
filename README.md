# Terraform Scripts for Development Environment

These terraform scripts are designed to allow development environments to be easily created for the purposes of remote - low-bandwidth work.

# Setup

When creating a service account for the terraform jobs, grant it the `Security Admin` permission.

`.creds` folder should include a copy of the GCP service account credentials for this to work.

Create an image for the jumpbox by changing the ssh port on an instance to 65432 and image from that disk, and name that image `jmpbx`.

# TODO

* Make it easy to create a new disk image for use as a development environment
* Keep images and boot an instance for them using a conditional apply statement (image name is repo name)
* Make ssh work to target internal IP from vscode SSH extension
