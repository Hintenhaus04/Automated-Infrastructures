variable "vpc_cidr" {
  description = "CIDR blok voor de VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR blok voor de Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "tags" {
  description = "Tags voor de resources"
  type        = map(string)
  default     = {
    name  = "Default"
    value = "Default"
  }
}
