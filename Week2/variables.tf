# Define a variable named "instance_type"
variable "instance_type" {
    type = string
    default = "t2.micro"
    description = "EC2 instance type"
}
