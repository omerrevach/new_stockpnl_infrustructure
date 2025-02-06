variable "vpc_id" {
  type        = string
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "public_subnet_id" {
  type        = string
}

variable "private_cidr_blocks" {
  type        = list(string)
}

variable "name" {
  type        = string
}
