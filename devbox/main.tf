provider "google" {
  version = "~> 3.0"
  
  credentials = file("../${var.credentials_file}")

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "devbox" {
  name         = "devbox"
  machine_type = "f1-micro"
  tags         = ["dev"]

  boot_disk {
    auto_delete = false
    source = var.repository
  }

  network_interface {
    network = var.network
    access_config {
      // This empty block assigns an Ephemeral IP
    }
  }
}
