provider "aws" {
  region = "eu-central-1"
}

module "no-policies" {
  source = "../../.."

  acl  = "public"
  name = "policies-bucket-example-wpas"

}
