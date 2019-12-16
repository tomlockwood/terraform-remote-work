# Terraform Scripts for Development Environment

These terraform scripts are designed to allow development environments to be easily created for the purposes of remote - low-bandwidth work.

# Setup

When creating a service account for the terraform jobs, grant it the `Security Admin` permission.

`.creds` folder should include a copy of the GCP service account credentials for this to work.

Create an image for the jumpbox by changing the ssh port on an instance to 65432 and make an image from that disk, and name that image `jmpbx`.

`make add-oslogin-key` adds your oslogin key from `gcloud` to allow ssh access.

# Using the ./tf script

This script is used to compartmentalize your terraform state, so you may have individual pieces of it up, while sharing outputs and variables between them.

The tf script:
 - Loads all the variables stored in the `*_outputs.json` files into environment variables
 - Shifts into the folder of the first argument
 - Runs `terraform` and passes it the second argument, (apply, destroy etc.)
 - Passes the same command the third argument (used for options like `-auto-approve`)
 - Returns to the main directory
 - Puts all outputs into the `*_outputs.json` file, with the first argument replacing the star

 # Using the ./diskcmd script

 This script creates a disk for any repository you want a separated development environment for.  The reason this occurs slightly differently to a regular `apply` or `destroy` command is that terraform has some trouble dynamically storing state in dynamically interpolated state file names.

 The diskcmd script:
 - Creates a directory in the `devdisk` directory named after the first argument (`repository` name) if none exists
 - Moves any files in the repository-named dir to the `devdisk` dir
 - Runs the ./tf script for the `devdisk` directory, passing it the `repository` as a variable
 - Moves the state for the devdisk to the repository-named dir

# TODO

* Retry on a new project
* Create interpolated ssh_config
* Automate key transfer to a new devbox
* Remove `.json` extension from output files
* Write a terraform script for making a generic devbox that uses an image with the repo as an argument
* Make ssh work to target internal IP from vscode SSH extension
