#Wout Achterhuis
#531598
#Date: 2021-09-06

provider "aws" {
    profile = "default"
    region  = "us-east-1"
}
terraform {
    backend "local" {}
}

resource "aws_vpc" "KlantA_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = { name = "KlantA", value = "KlantA"}
}

resource "aws_subnet" "KlantA_subnet" {
    vpc_id     = aws_vpc.KlantA_vpc.id
    cidr_block = "10.0.1.0/24"
    tags = { name = "KlantA", value = "KlantA"}
    map_public_ip_on_launch = true
}

resource "aws_route_table" "KlantA_rt" {
    vpc_id = aws_vpc.KlantA_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.KlantA_igw.id
    }
}

resource "aws_route_table_association" "KlantA_rta" {
    subnet_id      = aws_subnet.KlantA_subnet.id
    route_table_id = aws_route_table.KlantA_rt.id
}

resource "aws_internet_gateway" "KlantA_igw" {
    vpc_id = aws_vpc.KlantA_vpc.id
    tags = { name = "KlantA", value = "KlantA"}
}

resource "aws_security_group" "KlantA_sg" {
    vpc_id = aws_vpc.KlantA_vpc.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["10.0.0.0/16"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "KlantA_instance" {
    ami = "ami-071226ecf16aa7d96"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.KlantA_subnet.id
    vpc_security_group_ids = [aws_security_group.KlantA_sg.id]
    tags = { name = "KlantA", value = "KlantA"}
    associate_public_ip_address = true
    key_name = "key1"
}

resource "aws_instance" "KlantA_instance1" {
    ami = "ami-071226ecf16aa7d96"
    instance_type = var.instance_type
    subnet_id = aws_subnet.KlantA_subnet.id
    vpc_security_group_ids = [aws_security_group.KlantA_sg.id]
    tags = { name = "KlantA", value = "KlantA"}
    associate_public_ip_address = true
    key_name = "key1"
}
