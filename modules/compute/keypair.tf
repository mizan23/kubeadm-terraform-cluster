resource "aws_key_pair" "kube_key" {
  key_name   = "kube-key"
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
}