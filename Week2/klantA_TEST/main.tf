module "vpc" {
  source       = "../Modules/VPC"
  vpc_cidr     = "10.0.0.0/16"
  subnet_cidr  = "10.0.1.0/24"
  tags         = { name = "KlantA", value = "Test" }
}

module "sg" {
  source  = "../Modules/SecurityGroup"
  sg_name = "KlantA-sg"
  vpc_id  = module.vpc.vpc_id
  tags    = { name = "KlantA", value = "Test" }
}

module "server" {
  source              = "../Modules/Server"
  instance_count      = 1
  ami                 = "ami-071226ecf16aa7d96"
  instance_type       = "t2.micro"
  subnet_id           = module.vpc.subnet_id
  security_group_ids  = [module.sg.security_group_id]
  key_name            = "key1"
  instance_name       = "KlantA-Test"
  tags                = { name = "KlantA", value = "Test" }
}
