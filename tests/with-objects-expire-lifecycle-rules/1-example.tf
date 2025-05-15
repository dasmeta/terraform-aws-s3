module "this" {
  source = "../.."

  name = "with-objects-expire-lifecycle-rules-dasmeta"

  lifecycle_rules = [
    {
      id      = "remove-all-created-objects-after-1-day"
      enabled = true

      expiration = {
        days = 1
      }
      filter = {
        object_size_greater_than = 0
      }
    }
  ]
}
