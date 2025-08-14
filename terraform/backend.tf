terraform {
  /**
   * Remote state backend
   *
   * The Terraform state for this project is stored in an S3 bucket
   * with DynamoDB providing a state lock.  Before running `terraform init`
   * you must create these resources manually or via a bootstrap script and
   * supply the bucket and table names via the `backend_bucket` and
   * `backend_dynamodb_table` variables.
   */
  backend "s3" {
    bucket         = var.backend_bucket
    key            = "state/${var.project_name}/terraform.tfstate"
    region         = var.region
    dynamodb_table = var.backend_dynamodb_table
    encrypt        = true
  }
}