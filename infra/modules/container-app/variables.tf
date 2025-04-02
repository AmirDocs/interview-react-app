variable "name" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "container_env_id" {
  type = string
}

variable "location" {
  type = string
}

variable "image" {
  type = string
}

variable "acr_credentials" {
  type = object({
    username = string
    password = string
  })
}

variable "external_ingress" {
  type    = bool
  default = true
}

variable "target_port" {
  type    = number
  default = 80
}

variable "env_name" {
  type    = string
  default = "dev"
}
