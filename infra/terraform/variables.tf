variable "region" {
  type    = string
  default = "us-east-1"
}

variable "access_key" {
  type    = string
  default = "test"
}

variable "secret_key" {
  type    = string
  default = "test"
}

variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
}
