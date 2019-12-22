provider "google" {
  version = "~> 3.0"

  credentials = file("../${var.credentials_file}")

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

# OSLogin configuration - to allow external SSH access

resource "google_compute_project_metadata_item" "oslogin" {
  project = var.project
  key     = "enable-oslogin"
  value   = "TRUE"
}
