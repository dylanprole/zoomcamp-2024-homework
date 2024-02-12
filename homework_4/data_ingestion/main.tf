terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.13.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = var.my_project_id
  region  = var.region
}

resource "google_storage_bucket" "demo-bucket" {
  name                     = var.gcs_bucket_name
  location                 = var.location
  force_destroy            = true
  storage_class            = var.gcs_storage_class
  public_access_prevention = "enforced"

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id                 = var.bq_dataset_name
  delete_contents_on_destroy = true
  location                   = var.location
}