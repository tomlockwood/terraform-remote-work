variable "project" { }

variable "credentials_file" { }

variable "region" {
  default = "australia-southeast1"
}

variable "zone" {
  default = "australia-southeast1-b"
}

variable "cidrs" { default = [] }

variable "environment" {
  type = string
  default = "dev"
}

variable "machine_types" {
  type = map(string)
  default = {
    "dev" = "f1-micro"
    "test" = "n1-highcpu-32"
    "prod" = "n1-highcpu-32"
  }
}
