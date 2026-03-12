resource "aws_instance" "master" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = var.public_subnet
  vpc_security_group_ids = [var.security_group]

  associate_public_ip_address = true

  user_data = file("${path.module}/../../scripts/master.sh")

  tags = {
    Name = "kube-master"
  }
}