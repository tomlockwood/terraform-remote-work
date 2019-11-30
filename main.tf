provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
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
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["65432"]
  }
  source_ranges = ["${trimspace(data.http.icanhazip.body)}/32"]
}

# Allow internal connections from jumpbox to internal ssh port
resource "google_compute_firewall" "internal-allow-ssh" {
  name    = "internal-allow-ssh"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["${google_compute_instance.jmpbx.network_interface[0].network_ip}/32"]
}

# jmpbx image must accept ssh connections on port 65432
resource "google_compute_instance" "jmpbx" {
  name         = "jmpbx"
  machine_type = var.machine_types[var.environment]
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "jmpbx"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
      nat_ip = google_compute_address.jmpbx_ip.address
    }
  }
}

resource "google_compute_address" "jmpbx_ip" {
  name = "jmpbx-ip"
}

# OSLogin configuration - to allow external SSH access

resource "google_compute_project_metadata_item" "oslogin" {
  project = var.project
  key     = "enable-oslogin"
  value   = "TRUE"
}

resource "google_project_iam_member" "role-binding" {
  project = var.project
  role    = "roles/compute.osAdminLogin"
  member  = "user:${var.email}"
}
