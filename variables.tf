variable "project" { }

variable "credentials_file" { }

variable "email" {
  default = "axismech@gmail.com"
}

variable "region" {
  default = "australia-southeast1"
}

variable "zone" {
  default = "australia-southeast1-b"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "machine_types" {
  type = map(string)
  default = {
    "dev" = "f1-micro"
  }
}
