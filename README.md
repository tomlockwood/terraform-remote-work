# Terraform Scripts for Development Environment Creation on GCP

Designed for use with the [Remote - SSH](https://code.visualstudio.com/docs/remote/ssh) VSCode extension.

These terraform scripts are designed to allow development environments to be easily created for the purposes of remote - low-bandwidth work.  They create a jumpbox which allows ssh access into a development machine.

# Initial Setup

Install `gcloud` and run `gcloud auth login`.

If you want to create a new project: `gcloud projects create my-unique-remote-work-project-name --set-as-default`.  `--set-as-default` makes the next steps more convenient.  If you want to reverse this you can use `gcloud config set project my-actual-project`, or you can not use this flag and set `--project=my-unique-remote-work-project-name` in the next gcloud commands.

Create a billing account and associate it with your project, either in console or on the command line using `gcloud alpha billing projects link my-unique-remote-work-project-name --billing-account 0X0X0X-0X0X0X-0X0X0X`.

Enable osLogin on your account - which will allow you to ssh to compute boxes `gcloud projects add-iam-policy-binding my-unique-remote-work-project-name --member user:my-google-account@gmail.com --role roles/compute.osAdminLogin`.

Create a service account for your project at `https://console.cloud.google.com/iam-admin/serviceaccounts/create` and save the JSON key file to a directory in the root of this repo called `.creds`.  This folder is in `.gitignore`.

Create a `terraform.tfvars` file in the root directory of this repo with the following:

```
project = "my-unique-remote-work-project-name"
credentials_file = ".creds/my-project-keyfile.json"
region = "my-region1"
zone = "my-region1-a"
email = "my-google-account@gmail.com"
```

Enable compute API `gcloud services enable compute.googleapis.com`.

Run `./tf setup apply` to setup the VPC and add osLogin metadata.

There may be a step to setup a google ssh key - you can try to do this by creating an instance and then sshing into it using the `gcloud compute ssh my-instance-name` command.  If you have any difficulties here please show the steps you needed in an issue on this repo - you may not need to do this step if you have already logged into another instance on GCP.  You may need to run something like: `gcloud compute os-login ssh-keys add --key-file ~/.ssh/google_compute_engine.pub` after GCP asks for you to generate a key.  This allows your local key to be used to login to instances.

In order to make an image for the jumpbox, create an instance - with disk auto-delete off - and configure the ssh port on it to something non-standard - this repo currently uses `65432`.  Additionally on this box you could install some 2FA via something like google authenticator.  Once you're done, shut down the instance and create an image from that instance's disk named `jmpbx`, which these scripts will boot from a clean image as your jumpbox every time you run them.

# Creating a Development Environment

Each development environment consists primarily of a disk.  To create a new disk, run `./diskcmd my-disk-name apply`.  This will create a 10GB new debian-10 disk by default.  If you want to change these defaults - alter the code in `./devdisk/main.tf`.

Then, it should be as simple as running `./startup my-disk-name` to point a micro instance at that disk, and to create a `ssh_config` file in the root directory.  If your setup has been successful `ssh -F ssh_config devbox` should ssh you through the jumpbox and into your development instance.

This config file is also designed to work with the VSCode `Remote - SSH` extension, just add the `ssh_config` file path in this repo as the configuration path.  Every `./startup` this configuration is generated.  If you want to customize the output you can do this in `make_ssh`.  By default this tunnels port 8080 to localhost:65430 on your machine.  This is where you might expose your other development ports.

# Shutting Down a Development Environment

`./shutdown my-disk-name` will shut down your development environment.  If you want to shut down a specific devbox without shutting down the jumpbox, please see the more detailed sub-command descriptions below.  The configured VPC and some osLogin configuration will remain, as defined in the `setup` folder.

# Github key transfer

As an example of a convenient way to transfer ssh keys for github access to your devdisks - the scripts `github_init` and `github_devbox_init` are in the root directory of this repository.  `github_init` goes through locally creating a github key and uploading it to google secrets manager, and `github_devbox_init` enables download on the instance.

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

# TODO

* Retry on a totally clean image
* Run gcloud commands for initial project, service account setup, osLogin permissions and keygen
* Split ssh_config so someone could `ssh jumpbox` or `ssh devbox`
* Make port forwarding configurable
