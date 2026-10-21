# Existing S3 Bucket CORS

This child module manages the complete CORS configuration for an S3 bucket that already exists. It does not create or manage the bucket or any other bucket settings.

S3 supports one CORS configuration per bucket. This module replaces the full rule set with the rules declared by the consumer, so only one Terraform state or module should manage CORS for a bucket. Do not combine it with the root S3 module's `cors_rule` input for the same bucket.

## Usage

```terraform
module "existing_bucket_cors" {
  source = "dasmeta/s3/aws//modules/cors"

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
```

The bucket must already exist and the AWS provider must have permission to manage its CORS configuration. Review the plan to ensure it changes only CORS on the named bucket.

## Inputs

| Name | Description | Type | Required |
|---|---|---|:---:|
| `bucket` | Name of the existing S3 bucket. | `string` | yes |
| `cors_rule` | Complete CORS rule set. Each rule requires `allowed_methods` and `allowed_origins`; other attributes are optional. | `list(object)` | yes |
| `expected_bucket_owner` | Optional AWS account ID expected to own the bucket. | `string` | no |

## Resource Ownership

The module manages only `aws_s3_bucket_cors_configuration`. It does not create or change bucket policy, encryption, versioning, ACLs, public access settings, notifications, or objects.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_s3_bucket_cors_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Name of the existing S3 bucket whose complete CORS configuration this module manages. | `string` | n/a | yes |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | Complete CORS rule set for the existing bucket. This module owns all CORS rules on the bucket. | <pre>list(object({<br/>    id              = optional(string)       # Optional stable identifier for the CORS rule.<br/>    allowed_methods = list(string)           # HTTP methods allowed for the rule's origins.<br/>    allowed_origins = list(string)           # Origins allowed to access the bucket.<br/>    allowed_headers = optional(list(string)) # Request headers allowed by browser preflight.<br/>    expose_headers  = optional(list(string)) # Response headers exposed to browser code.<br/>    max_age_seconds = optional(number)       # Seconds that browsers may cache the preflight response.<br/>  }))</pre> | n/a | yes |
| <a name="input_expected_bucket_owner"></a> [expected\_bucket\_owner](#input\_expected\_bucket\_owner) | Optional AWS account ID expected to own the bucket. When set, AWS rejects requests if the owner does not match. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
