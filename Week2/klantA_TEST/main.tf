# Module for creating a VPC with a specified CIDR block and subnet
module "vpc" {
  source       = "../Modules/VPC"         # Path to the VPC module
  vpc_cidr     = "10.0.0.0/16"           # CIDR block for the VPC
  subnet_cidr  = "10.0.1.0/24"           # CIDR block for the subnet
  tags         = { name = "KlantA", value = "Test" } # Tags for the VPC resources
}

# Module for creating a Security Group within the VPC
module "sg" {
  source  = "../Modules/SecurityGroup"   # Path to the Security Group module
  sg_name = "KlantA-sg"                  # Name of the Security Group
  vpc_id  = module.vpc.vpc_id            # Reference to the VPC ID from the VPC module
  tags    = { name = "KlantA", value = "Test" } # Tags for the Security Group
}

# Module for creating an EC2 instance
module "server" {
  source              = "../Modules/Server"       # Path to the Server module
  instance_count      = 1                         # Number of instances to create
  ami                 = "ami-071226ecf16aa7d96"   # AMI ID for the instance
  instance_type       = "t2.micro"                # Instance type
  subnet_id           = module.vpc.subnet_id      # Subnet ID from the VPC module
  security_group_ids  = [module.sg.security_group_id] # Security Group ID from the SG module
  key_name            = "key1"                    # Key pair name for SSH access
  instance_name       = "KlantA-Test"             # Name of the instance
  tags                = { name = "KlantA", value = "Test" } # Tags for the instance
}
