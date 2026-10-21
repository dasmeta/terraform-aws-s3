variable "bucket" {
  type        = string
  description = "Name of the existing S3 bucket whose complete CORS configuration this module manages."

  validation {
    condition     = length(trimspace(var.bucket)) > 0
    error_message = "The bucket name must not be empty."
  }
}

variable "cors_rule" {
  type = list(object({
    id              = optional(string)       # Optional stable identifier for the CORS rule.
    allowed_methods = list(string)           # HTTP methods allowed for the rule's origins.
    allowed_origins = list(string)           # Origins allowed to access the bucket.
    allowed_headers = optional(list(string)) # Request headers allowed by browser preflight.
    expose_headers  = optional(list(string)) # Response headers exposed to browser code.
    max_age_seconds = optional(number)       # Seconds that browsers may cache the preflight response.
  }))
  description = "Complete CORS rule set for the existing bucket. This module owns all CORS rules on the bucket."

  validation {
    condition     = length(var.cors_rule) > 0
    error_message = "At least one CORS rule is required."
  }
}

variable "expected_bucket_owner" {
  type        = string
  default     = null
  description = "Optional AWS account ID expected to own the bucket. When set, AWS rejects requests if the owner does not match."
}
