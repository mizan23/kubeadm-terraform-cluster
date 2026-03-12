variable "worker_count" {
  type    = number
  default = 2
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "key_name" {
  type = string
}

variable "security_group" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet" {
  description = "Public subnet for Kubernetes master"
  type        = string
}

variable "private_subnet" {
  description = "Private subnet for worker nodes"
  type        = string
}