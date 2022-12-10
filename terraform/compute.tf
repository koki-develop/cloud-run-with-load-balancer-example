resource "google_compute_global_address" "main" {
  name = "${local.name}-address"
}

resource "google_compute_managed_ssl_certificate" "main" {
  name = "${local.name}-cert"
  managed {
    domains = [var.domain]
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "${local.name}-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = google_cloud_run_service.main.name
  }
}
