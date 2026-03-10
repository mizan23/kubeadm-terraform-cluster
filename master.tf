resource "aws_instance" "master" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.kube_key.key_name

  subnet_id = aws_subnet.kube_subnet.id
  vpc_security_group_ids = [aws_security_group.kube_sg.id]

  associate_public_ip_address = true

  user_data = file("scripts/master.sh")

  tags = {
    Name = "kube-master"
  }
}