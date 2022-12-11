data "google_dns_managed_zone" "main" {
  name = "kokitest"
}

resource "google_dns_record_set" "main" {
  name         = local.domain
  type         = "A"
  managed_zone = data.google_dns_managed_zone.main.name
  rrdatas      = [google_compute_global_address.main.address]
}
