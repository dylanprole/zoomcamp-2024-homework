variable "my_project_id" {
  description = "My current project id"
  default     = "taxi-rides-ny-412407"
}

variable "location" {
  description = "My default resource location"
  default     = "AUSTRALIA-SOUTHEAST1"
}

variable "bq_dataset_name" {
  description = "My BigQuery dataset name"
  default     = "nytaxi"
}

variable "gcs_bucket_name" {
  description = "My storage bucket name"
  default     = "taxi-rides-ny-412407-bigquery"
}

variable "gcs_storage_class" {
  description = "Bucket storage class"
  default     = "STANDARD"
}

variable "region" {
  description = "My default resource region"
  default     = "australia-southeast1"
}