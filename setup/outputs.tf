output "ssh_user" {
  value = replace(replace(var.email,"@","_"),".","_")
}

output "network" {
  value = google_compute_network.vpc_network.self_link
}
