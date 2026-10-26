# aws S3 bucket and iam user with access to it

Creates AWS S3 bucket and if there is need IAM user with appropriated accesses to list/get/put/delete objects in it.

# Use Cases

## Case 1: simple use case with minimal params

```terraform

module "my_bucket" {
  source = "dasmeta/s3/aws"
  version = "1.2.1"

  name = "my-files-bucket"
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.my_bucket.iam_access_key_id
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.my_bucket.iam_user_arn
}
```

## Case 2: with some additional params, by disabling iam user creation

```terraform
module "my_bucket" {
  source = "dasmeta/s3/aws"
  version = "1.2.1"

  name = "my-files-bucket"

  acl    = "public"

  versioning = {
    enabled = true
  }

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }
}
```

## Case 3: website with initial index.html and "/images/\*\*" content

```terraform
module "my_bucket" {
  source = "dasmeta/s3/aws"
  version = "1.2.1"

  name = "my-website"

  versioning = {
    enabled = true
  }

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  create_index_html = true
  bucket_files = "{module.path}/images"
}
```

## Configure CORS on an existing bucket

Use the `//modules/cors` child module when the bucket is already managed elsewhere and only its CORS configuration should be managed here. The child module does not create or change the bucket.

S3 has one complete CORS configuration per bucket. This module owns the full rule set; do not use it alongside another Terraform state or the root module's `cors_rule` input for the same bucket.

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

See [the existing-bucket CORS example](examples/existing-bucket-cors/1-example.tf) for the provider setup and usage.

## Adopt a bucket into the root module

The root module manages the bucket and its configured settings, including CORS. For an existing bucket, record its live ACL, ownership controls, policy, public access block, encryption, tags, and CORS rules before configuring the module. `bucket_policy_json` can preserve a complete policy that the generated public policy or `bucket_iam_policy` cannot represent. It takes precedence over both generated policies. Set `attach_public_access_block = false` if the bucket has no public access block configuration.

Import each configured S3 resource into the new workspace before applying. When the root module is called as `module "<name>"`, use these consumer-side addresses for the resources that are enabled:

- `module.<name>.module.bucket.aws_s3_bucket.this[0]`
- `module.<name>.module.bucket.aws_s3_bucket_acl.this[0]`
- `module.<name>.module.bucket.aws_s3_bucket_ownership_controls.this[0]`
- `module.<name>.module.bucket.aws_s3_bucket_policy.this[0]`
- `module.<name>.module.bucket.aws_s3_bucket_server_side_encryption_configuration.this[0]`
- `module.<name>.module.bucket.aws_s3_bucket_cors_configuration.this[0]`
- `module.<name>.module.bucket.aws_s3_bucket_public_access_block.this[0]` when `attach_public_access_block = true` (the default)

Set `attach_public_access_block = false` when the existing bucket has no public access block. Otherwise, import its public access block and configure the `block_*`, `ignore_public_acls`, and `restrict_public_buckets` values to match the live settings. Review the resulting plan for changes to any existing bucket setting before applying it.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_bucket"></a> [bucket](#module\_bucket) | terraform-aws-modules/s3-bucket/aws | 4.8.0 |
| <a name="module_bucket_files"></a> [bucket\_files](#module\_bucket\_files) | ./modules/objects | n/a |
| <a name="module_iam_user"></a> [iam\_user](#module\_iam\_user) | dasmeta/modules/aws//modules/aws-iam-user | 0.36.1 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_s3_bucket_intelligent_tiering_configuration.bucket_intelligent_tiering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_notification.bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_object.index](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_sqs_queue.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_acl"></a> [acl](#input\_acl) | The acl config for bucket, NOTE: 'acl' conflicts with 'grant' and 'owner'. | `string` | `"private"` | no |
| <a name="input_attach_public_access_block"></a> [attach\_public\_access\_block](#input\_attach\_public\_access\_block) | Whether to manage an S3 bucket public access block configuration. Set false when importing a bucket without one. | `bool` | `true` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `false` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `false` | no |
| <a name="input_bucket_files"></a> [bucket\_files](#input\_bucket\_files) | Initial content for bucket, use acl and pattern params if you need more control. | <pre>object({<br/>    path = string<br/>  })</pre> | <pre>{<br/>  "path": ""<br/>}</pre> | no |
| <a name="input_bucket_iam_policy"></a> [bucket\_iam\_policy](#input\_bucket\_iam\_policy) | AWS bucket policy | <pre>list(object({<br/>    effect     = optional(string, "Allow") # Effect of the policy (Allow or Deny)<br/>    actions    = list(string)              # Actions like sts:AssumeRole<br/>    principals = any                       # Principals (e.g., AWS, Service, Federated)<br/>    conditions = optional(any, [])         # Optional conditions for assume role<br/>  }))</pre> | `[]` | no |
| <a name="input_bucket_intelligent_tiering"></a> [bucket\_intelligent\_tiering](#input\_bucket\_intelligent\_tiering) | Intelligent lifecycle policy. This can be used to automatically archive objects based on days | <pre>list(object({<br/>    tier = string<br/>    days = number<br/>  }))</pre> | `[]` | no |
| <a name="input_bucket_policy_json"></a> [bucket\_policy\_json](#input\_bucket\_policy\_json) | Complete bucket policy JSON. Overrides the generated public or bucket\_iam\_policy document when set. | `string` | `null` | no |
| <a name="input_control_object_ownership"></a> [control\_object\_ownership](#input\_control\_object\_ownership) | Manage S3 Bucket Ownership Controls on this bucket or not. | `bool` | `false` | no |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | List of maps containing rules for Cross-Origin Resource Sharing. | `any` | `[]` | no |
| <a name="input_create_iam_user"></a> [create\_iam\_user](#input\_create\_iam\_user) | Whether to create specific api access user to this created bucket. | `bool` | `false` | no |
| <a name="input_create_index_html"></a> [create\_index\_html](#input\_create\_index\_html) | Whether to create and initial index.html file with default data. | `bool` | `false` | no |
| <a name="input_event_notification_config"></a> [event\_notification\_config](#input\_event\_notification\_config) | n/a | <pre>object({<br/>    target_type   = string,                                        // Target type for the S3 event notification, can be "sqs" or "null". Other target types can be implemented in the future.<br/>    name_suffix   = string,                                        // Suffix to add to the target name.<br/>    filter_prefix = string,                                        // Prefix to filter object key names for the event notification.<br/>    events        = optional(list(string), ["s3:ObjectCreated:*"]) // List of S3 events that trigger the notification. Defaults to "s3:ObjectCreated:*".<br/>  })</pre> | <pre>{<br/>  "events": [<br/>    "s3:ObjectCreated:*"<br/>  ],<br/>  "filter_prefix": "test/",<br/>  "name_suffix": "event",<br/>  "target_type": "null"<br/>}</pre> | no |
| <a name="input_expected_bucket_owner"></a> [expected\_bucket\_owner](#input\_expected\_bucket\_owner) | AWS account ID expected to own the bucket and its configuration. | `string` | `null` | no |
| <a name="input_grant"></a> [grant](#input\_grant) | The ACL policy grant. NOTE: conflicts with 'acl'. | `any` | `[]` | no |
| <a name="input_iam_user_actions"></a> [iam\_user\_actions](#input\_iam\_user\_actions) | The allowed actions that created user can perform on this created bucket. | `list(string)` | <pre>[<br/>  "s3:PutObject",<br/>  "s3:ListBucket",<br/>  "s3:GetObject",<br/>  "s3:GetObjectVersion",<br/>  "s3:GetBucketAcl",<br/>  "s3:DeleteObject",<br/>  "s3:DeleteObjectVersion",<br/>  "s3:PutLifecycleConfiguration",<br/>  "s3:PutObjectAcl"<br/>]</pre> | no |
| <a name="input_iam_user_name"></a> [iam\_user\_name](#input\_iam\_user\_name) | The name of user, NOTE: this is optional and if it is not passed in use place the name will be generated based on bucket name. | `string` | `""` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `false` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of maps containing configuration of object lifecycle management. This can be used to remove expired object based on days and date | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Bucket name. | `string` | n/a | yes |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Object ownership. | `string` | `"BucketOwnerPreferred"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | The Bucket owner's display name and ID. NOTE: Conflicts with 'acl'. | `map(string)` | `{}` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `false` | no |
| <a name="input_server_side_encryption_configuration"></a> [server\_side\_encryption\_configuration](#input\_server\_side\_encryption\_configuration) | Map containing server-side encryption configuration for the bucket. | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign to the bucket. | `map(string)` | `{}` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | The versioning configuration for the created bucket. | `map(string)` | `{}` | no |
| <a name="input_website"></a> [website](#input\_website) | The website configuration for the created bucket. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The bucket regional domain name |
| <a name="output_iam_access_key_id"></a> [iam\_access\_key\_id](#output\_iam\_access\_key\_id) | The access key ID |
| <a name="output_iam_access_key_secret"></a> [iam\_access\_key\_secret](#output\_iam\_access\_key\_secret) | The access key secret |
| <a name="output_iam_user_arn"></a> [iam\_user\_arn](#output\_iam\_user\_arn) | The ARN assigned by AWS for this user |
| <a name="output_iam_user_name"></a> [iam\_user\_name](#output\_iam\_user\_name) | The user's name |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The bucket arn |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The bucket name |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | The website endpoint associated to created s3 bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
