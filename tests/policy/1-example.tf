
provider "aws" {
  region = "eu-central-1"
}

module "external-policies" {
  source = "../.."

  acl = "private"
  name = "policies-bucket-example-wpas"
  attach_policy = true

  policy = jsonencode({
    "Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "module-test-statID-stqw",
			"Effect": "Allow",
			"Principal": {
				"AWS": "*"
			},
			"Action": [
				"s3:GetObject",
				"s3:PutObject",
				"s3:PutObjectAcl",
				"s3:ListBucket",
			],
			"Resource": [
				"arn:aws:s3:::policies-bucket-example-wpas",
				"arn:aws:s3:::policies-bucket-example-wpas/*",
			]
		}
	]
  })
}