module "existing_bucket_cors" {
  source = "../../modules/cors"

  bucket                = "existing-upload-bucket"
  expected_bucket_owner = "123456789012"

  cors_rule = [
    {
      allowed_methods = ["POST", "PUT"]
      allowed_origins = ["https://admin.example.com"]
      allowed_headers = ["*"]
      expose_headers  = ["ETag", "Location"]
      max_age_seconds = 3000
    }
  ]
}
