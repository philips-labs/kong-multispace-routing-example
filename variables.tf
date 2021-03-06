variable "cf_user" {
  type = string
}

variable "cf_password" {
  type = string
}

variable "cf_org_name" {
  type = string
}

variable "cf_space_name" {
  type = string
}

variable "region" {
  type = string
}

variable "teams" {
  type    = number
  default = 4
}
