
output "devbox_ip" {
  value = google_compute_instance.devbox.network_interface.0.network_ip
}
