output "jmpbx_ip" {
  value = google_compute_instance.jmpbx.network_interface.0.access_config.0.nat_ip
}
