resource "aws_instance" "worker" {

  count = var.worker_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = var.private_subnet
  vpc_security_group_ids = [var.security_group]

  associate_public_ip_address = false

  user_data = templatefile("${path.module}/../../scripts/worker.sh", {
    master_ip = aws_instance.master.private_ip
  })

  depends_on = [
    aws_instance.master
  ]

  tags = {
    Name = "kube-worker-${count.index}"
  }
}