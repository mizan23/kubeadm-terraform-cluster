resource "aws_instance" "worker" {

  count = var.worker_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.kube_sg.id]
  associate_public_ip_address = false

  

  user_data = templatefile("scripts/worker.sh", {
    master_ip = aws_instance.master.private_ip
  })

  depends_on = [
    aws_instance.master
  ]

  tags = {
    Name = "kube-worker-${count.index}"
  }
}