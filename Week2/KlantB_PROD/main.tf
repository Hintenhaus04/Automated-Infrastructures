# Module for creating a VPC with a specified CIDR block and subnet
module "vpc" {
  source       = "../Modules/VPC"          # Path to the VPC module
  vpc_cidr     = "10.0.0.0/16"             # CIDR block for the VPC
  subnet_cidr  = "10.0.1.0/24"             # CIDR block for the subnet
  tags         = { name = "KlantB", value = "Prod" }  # Tags for the VPC
}

# Module for creating a Security Group within the VPC
module "sg" {
  source  = "../Modules/SecurityGroup"     # Path to the Security Group module
  sg_name = "KlantB-sg"                    # Name of the Security Group
  vpc_id  = module.vpc.vpc_id              # Reference to the VPC ID from the VPC module
  tags    = { name = "KlantB", value = "Prod" }  # Tags for the Security Group
}

# Module for creating EC2 instances
module "server" {
  source              = "../Modules/Server"        # Path to the Server module
  instance_count      = 3                          # Number of EC2 instances to create
  ami                 = "ami-071226ecf16aa7d96"    # AMI ID for the instances
  instance_type       = "t2.micro"                 # Instance type
  subnet_id           = module.vpc.subnet_id       # Subnet ID from the VPC module
  security_group_ids  = [module.sg.security_group_id]  # Security Group ID from the SG module
  key_name            = "key1"                     # Key pair name for SSH access
  instance_name       = "KlantB-Prod"              # Name for the EC2 instances
  tags                = { name = "KlantB", value = "Prod" }  # Tags for the instances
}
