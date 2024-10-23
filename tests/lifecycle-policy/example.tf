
provider "aws" {
  region = "eu-central-1"
}

module "custom-policies" {
  source = "../.."

  acl  = "private"
  name = "policies-bucket-example-wpas-2"

  bucket_intelligent_tiering = [{
    tier = "ARCHIVE_ACCESS"
    days = 90
  }]
}
