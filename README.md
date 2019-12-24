# Terraform Scripts for Development Environment

These terraform scripts are designed to allow development environments to be easily created for the purposes of remote - low-bandwidth work.

# Setup

Install `gcloud` and run `gcloud auth login`.

Run `./init` with arguments in the following order:
1) Desired project id
2) GCP account e-mail address - as set in the `gcloud auth login` flow
3) Desired region (e.g. `australia-southeast1`)
4) Desired zone (e.g. `australia-southeast1-b`)

Create an image for the jumpbox by changing the ssh port on an instance one you like and make an image from that disk, and name that image `jmpbx`.

TODO: Set the port in the required locations in the terraform script.
TODO: Make sure the oslogin ssh key is generated???

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

This script creates a disk for any repository you want a separated development environment for.  The reason this occurs slightly differently to a regular `apply` or `destroy` command is that terraform has some trouble storing state in dynamically interpolated state file names.

The diskcmd script:
 - Creates a directory in the `devdisk` directory named after the first argument (`repository` name) if none exists
 - Moves any files in the repository-named dir to the `devdisk` dir
 - Runs the ./tf script for the `devdisk` directory, passing it the `repository` as a variable
 - Moves the state for the devdisk to the repository-named dir

# Using the ./boxcmd script

This script creates an instance that points at a `devdisk`.

The boxcmd script:
 - Acts identically to the `tf` script, but the first argument is the devdisk name
 - It always acts on the devbox folder

 # Using the ./make_ssh script

This script creates a custom ssh_config file you can point SSH at.

The make_ssh script:
 - Gathers outputs from `setup` and the `devbox` that is applied currently
 - Writes a new file to `ssh_config` in the base directory of this repository

 This script can be used either as an input to the ssh command (e.g. `ssh -F ssh_config devbox`) or can be pointed to by another tool, like the VSCode `Remote - SSH` extension.

# Github key transfer

TODO

# TODO

* Retry on a new project
* Run gcloud commands for initial project, service account setup, osLogin permissions and keygen
* NAT in a separate script, with an argument on "startup" script to enable it - remove devbox external IP
* Optional scheduled job in gcp to shutdown all infra at a preset time???
* Split ssh_config so someone could `ssh jumpbox` or `ssh devbox`
