provider "google" {
  project = "proyecto-avatares-lsm"
  region  = "us-central1"
  credentials = file("<path-to-your-service-account-key>.json")
}
