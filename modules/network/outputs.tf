output "vpc_id" {
  value = aws_vpc.kube_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.kube_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}