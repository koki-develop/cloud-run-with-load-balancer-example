terraform {
  backend "gcs" {
    bucket = "koki-test-tfstates"
    prefix = "cloud-run-with-load-balancer-example"
  }
}
