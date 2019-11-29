
output "jmpbx_ip" {
  value = google_compute_address.jmpbx_ip.address
}

output "ssh_user" {
  value = replace(replace(var.email,"@","_"),".","_")
}
