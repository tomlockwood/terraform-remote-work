provider "google" {
  credentials = file("../${var.credentials_file}")

  project = var.project
  region  = var.region
  zone    = var.zone
}

terraform {
  backend "gcs" {
    bucket = "terraform_backend_${var.project}"
    prefix = var.repository
  }
}

resource "google_compute_disk" "devdisk" {
  size = "10"
  name  = var.repository
  zone  = var.zone
  image = "debian-cloud/debian-10"
  labels = {
    environment = "dev"
  }
}
