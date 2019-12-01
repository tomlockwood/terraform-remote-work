provider "google" {
  credentials = file("../${var.credentials_file}")

  project = var.project
  region  = var.region
  zone    = var.zone
}

# Local state
data "terraform_remote_state" "local_backend" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

# Firewall only allows ssh connections to the box from the public ip of
# the local machine
data "http" "icanhazip" {
   url = "http://icanhazip.com"
}

# Allow connections to jumpbox only via the custom ssh port
# And only your current ip
resource "google_compute_firewall" "external-jumpbox-allow-ssh" {
  name    = "external-jumpbox-allow-ssh"
  network = data.terraform_remote_state.local_backend.outputs.network
  allow {
    protocol = "tcp"
    ports    = ["65432"]
  }
  source_ranges = ["${trimspace(data.http.icanhazip.body)}/32"]
}

# Allow internal connections from jumpbox to internal ssh port
resource "google_compute_firewall" "internal-allow-ssh" {
  name    = "internal-allow-ssh"
  network = data.terraform_remote_state.local_backend.outputs.network
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["${google_compute_instance.jmpbx.network_interface[0].network_ip}/32"]
}

# jmpbx image must accept ssh connections on port 65432
resource "google_compute_instance" "jmpbx" {
  name         = "jmpbx"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "jmpbx"
    }
  }

  network_interface {
    network = data.terraform_remote_state.local_backend.outputs.network
    access_config {
      nat_ip = data.terraform_remote_state.local_backend.outputs.jmpbx_ip
    }
  }
}