terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

resource "google_bigquery_dataset" "dev_dataset" {
  dataset_id = var.bq_dataset_dev
  location   = var.location
}

resource "google_bigquery_dataset" "staging_dataset" {
  dataset_id = var.bq_dataset_staging
  location   = var.location
}

resource "google_bigquery_dataset" "prod_dataset" {
  dataset_id = var.bq_dataset_prod
  location   = var.location
}