locals {
  image_server = regex("^([^/]+)", var.image)[0]
}
