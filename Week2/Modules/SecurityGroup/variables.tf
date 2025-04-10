variable "sg_name" {
  description = "Naam van de security group"
  type        = string
  default     = "DefaultSG"
}

variable "vpc_id" {
  description = "ID van de VPC"
  type        = string
}

variable "ssh_port" {
  description = "SSH poort"
  type        = number
  default     = 22
}

variable "ssh_cidr" {
  description = "Toegestane CIDR voor SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_port" {
  description = "HTTP poort"
  type        = number
  default     = 80
}

variable "http_cidr" {
  description = "Toegestane CIDR voor HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_port" {
  description = "HTTPS poort"
  type        = number
  default     = 443
}

variable "https_cidr" {
  description = "Toegestane CIDR voor HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "internal_cidr" {
  description = "Intern CIDR blok"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  description = "Tags voor de security group"
  type        = map(string)
  default     = {
    name  = "Default"
    value = "Default"
  }
}
