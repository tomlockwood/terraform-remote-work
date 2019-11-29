provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

data "http" "icanhazip" {
   url = "http://icanhazip.com"
}

resource "google_compute_firewall" "firewall-allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["${trimspace(data.http.icanhazip.body)}/32"]
}

resource "google_compute_instance" "jmpbx" {
  name         = "jmpbx"
  machine_type = var.machine_types[var.environment]
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
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