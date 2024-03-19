variable "credentials" {
  description = "My Credentials"
  default     = "./.keys/taxi-rides-ny-412407-b1f79a23e453.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
}

variable "project" {
  description = "Project"
  default     = "taxi-rides-ny-412407"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default = "australia-southeast1"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default = "US"
}

variable "bq_dataset_dev" {
  description = "Development BigQuery dataset"
  #Update the below to what you want your dataset to be called
  default = "dev"
}

variable "bq_dataset_staging" {
  description = "Staging BigQuery dataset"
  #Update the below to what you want your dataset to be called
  default = "staging"
}

variable "bq_dataset_prod" {
  description = "Production BigQuery dataset"
  #Update the below to what you want your dataset to be called
  default = "prod"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default = "taxi-rides-ny-412407-terraform-demo-terraform-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}