resource "google_compute_global_address" "main" {
  name = "${local.name}-address"
}
