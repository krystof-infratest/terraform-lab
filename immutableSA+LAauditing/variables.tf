variable "location" {
  type    = string
  default = "westeurope"
}

variable "environment_prefix" {
  type    = string
  default = "audit"
}

variable "retention_days" {
  type    = number
  default = 1
}
