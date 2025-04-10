variable "instance_count" {
  description = "Aantal instances"
  type        = number
  default     = 1
}

variable "ami" {
  description = "AMI voor de instance"
  type        = string
  default     = "ami-071226ecf16aa7d96"
}

variable "instance_type" {
  description = "Type instance"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "ID van de subnet waarin de instance komt"
  type        = string
}

variable "security_group_ids" {
  description = "Lijst met security group IDs"
  type        = list(string)
}

variable "key_name" {
  description = "Naam van het key pair"
  type        = string
  default     = "key1"
}

variable "instance_name" {
  description = "Basisnaam voor de instances"
  type        = string
  default     = "Instance"
}

variable "tags" {
  description = "Tags voor de instance(s)"
  type        = map(string)
  default     = {
    name  = "Default"
    value = "Default"
  }
}
