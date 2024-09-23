module "external-policies" {
  source = "../.."

  name = "policies-bucket"
  attach_policy = true

  policy = {
    "Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "module-test-statID",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::*:user/*"
			},
			"Action": [
				"s3:GetObject",
				"s3:PutObject",
				"s3:PutObjectAcl",
				"s3:ListBucket",
			],
			"Resource": [
				"arn:aws:s3:::policies-bucket",
				"arn:aws:s3:::policies-bucket/*"
			]
		}
	]
  }
}