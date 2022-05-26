variable "vpc_subnet_cidr-block" {
  type = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "instance_type" {
  default = "t2.micro"
}