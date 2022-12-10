resource "google_compute_global_address" "main" {
  name = "${local.name}-address"
}

resource "google_compute_managed_ssl_certificate" "main" {
  name = "${local.name}-cert"
  managed {
    domains = [var.domain]
  }
}
