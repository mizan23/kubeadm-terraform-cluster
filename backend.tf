terraform {
  backend "s3" {
    bucket         = "mizanur-kubeadm-cluster-tfstate-2026"
    key            = "kubeadm-cluster/terraform.tfstate"
    region         = "eu-central-1"
    profile        = "mizan23"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}