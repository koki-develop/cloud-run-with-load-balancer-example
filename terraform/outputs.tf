output "domain" {
  value = local.domain
}

output "load_balancer_ip" {
  value = google_compute_global_address.main.address
}
