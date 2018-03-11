

variable "public_key_path" {
  default = "~/.ssh/terrafrom.pub"
}

variable "aws_key_name" {
  description = "Desired name of AWS key pair"
  default = "terraform"
}

#variable "aws_secret_key" {}
#variable "aws_key_path" {}
#variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "eu-west-1"
}

variable "aws_availability_zone" {
    description = "EC2 Region for the VPC"
    default = "eu-west-1a"
}

variable "amis" {
    description = "AMIs by region"
    default = {
        eu-west-1 = "ami-1b791862"
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}

variable "vpc_id" {
    description = "VPC ID"
    default = "vpc-2a4d5b4d"
}