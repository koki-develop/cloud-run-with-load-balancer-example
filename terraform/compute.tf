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

resource "google_compute_backend_service" "main" {
  name = "${local.name}-backend"

  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}

resource "google_compute_url_map" "main" {
  name            = "${local.name}-urlmap"
  default_service = google_compute_backend_service.main.id
}

resource "google_compute_target_https_proxy" "main" {
  name             = "${local.name}-https-proxy"
  url_map          = google_compute_url_map.main.id
  ssl_certificates = [google_compute_managed_ssl_certificate.main.id]
}

resource "google_compute_global_forwarding_rule" "main" {
  name       = "${local.name}-lb"
  target     = google_compute_target_https_proxy.main.id
  port_range = "443"
  ip_address = google_compute_global_address.main.address
}

resource "google_compute_url_map" "http_to_https" {
  name = "${local.name}-http-to-https"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "http_to_https" {
  name    = "${local.name}-http-to-https"
  url_map = google_compute_url_map.http_to_https.id
}

resource "google_compute_global_forwarding_rule" "http_to_https" {
  name       = "${local.name}-lb-http-to-https"
  target     = google_compute_target_http_proxy.http_to_https.id
  port_range = "80"
  ip_address = google_compute_global_address.main.address
}
