terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.41.0"
    }
  }
}

provider "google" {
  credentials = file("token.json")

  project = "lab-devops-05"
  region  = "us-central1"
  zone    = "us-central1-a"
}