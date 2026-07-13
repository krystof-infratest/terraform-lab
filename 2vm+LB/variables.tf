variable "vnet_name" {
  type        = string
  default     = "vnet-emea_we_golab-krystof_001"
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["192.168.0.0/24"]
}

variable "subnet_name" {
  type        = string
  default     = "snet-core-001"
}

variable "subnet_prefix" {
  type        = list(string)
  default     = ["192.168.0.0/26"]
}

variable "vm_names" {
  type        = list(string)
  default     = ["vm-lab-back-01", "vm-lab-back-02"]
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  type        = string
  default     = "labadmin"
}

variable "admin_password" {
  type        = string
  default     = "RandomPassword.34"
}

variable "lb_private_ip" {
  type        = string
  default     = "192.168.0.10"
}