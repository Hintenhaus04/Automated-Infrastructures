resource "aws_instance" "this" {
  count = var.instance_count

  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = merge(var.tags, { Name = "${var.instance_name}-${count.index + 1}" })
}
