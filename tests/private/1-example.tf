module "private" {
  source = "../.."

  name = "dasmeta-dev-private"
}

module "private-explicitly" {
  source = "../.."

  name = "dasmeta-dev-private-explicitly"
  acl  = "private"
}
