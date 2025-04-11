# Wout Achterhuis
# 531598
# Date: 2021-09-06

# Configure the AWS provider with default profile and region
provider "aws" {
    profile = "default"
    region  = "us-east-1"
}

# Configure Terraform to use a local backend for state management
terraform {
    backend "local" {}
}

# Create a VPC with a specific CIDR block
resource "aws_vpc" "KlantA_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = { name = "KlantA", value = "KlantA" }
}

# Create a public subnet within the VPC
resource "aws_subnet" "KlantA_subnet" {
    vpc_id     = aws_vpc.KlantA_vpc.id
    cidr_block = "10.0.1.0/24"
    tags = { name = "KlantA", value = "KlantA" }
    map_public_ip_on_launch = true
}

# Create a route table for the VPC with a default route to the internet
resource "aws_route_table" "KlantA_rt" {
    vpc_id = aws_vpc.KlantA_vpc.id
    route {
        cidr_block = "0.0.0.0/0" # Default route for all traffic
        gateway_id = aws_internet_gateway.KlantA_igw.id
    }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "KlantA_rta" {
    subnet_id      = aws_subnet.KlantA_subnet.id
    route_table_id = aws_route_table.KlantA_rt.id
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "KlantA_igw" {
    vpc_id = aws_vpc.KlantA_vpc.id
    tags = { name = "KlantA", value = "KlantA" }
}

# Create a security group with specific ingress and egress rules
resource "aws_security_group" "KlantA_sg" {
    vpc_id = aws_vpc.KlantA_vpc.id

    # Allow SSH access from anywhere
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow HTTP access from anywhere
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow HTTPS access from anywhere
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all traffic within the VPC
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["10.0.0.0/16"]
    }

    # Allow all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Launch the first EC2 instance in the subnet with the security group
resource "aws_instance" "KlantA_instance" {
    ami = "ami-071226ecf16aa7d96" # Amazon Linux 2 AMI
    instance_type = "t2.micro"
    subnet_id = aws_subnet.KlantA_subnet.id
    vpc_security_group_ids = [aws_security_group.KlantA_sg.id]
    tags = { name = "KlantA", value = "KlantA" }
    associate_public_ip_address = true
    key_name = "key1" # SSH key pair
}

# Launch the second EC2 instance in the subnet with the security group
resource "aws_instance" "KlantA_instance1" {
    ami = "ami-071226ecf16aa7d96" # Amazon Linux 2 AMI
    instance_type = "t2.micro"
    subnet_id = aws_subnet.KlantA_subnet.id
    vpc_security_group_ids = [aws_security_group.KlantA_sg.id]
    tags = { name = "KlantA", value = "KlantA" }
    associate_public_ip_address = true
    key_name = "key1" # SSH key pair
}
