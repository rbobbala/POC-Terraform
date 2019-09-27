#variable "aws_access_key" {}
#variable "aws_secret_key" {}
variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {
  default = "us-east-1"
}

variable "ssh_key_public" {
  default     = "~/.ssh/id_rsa.pub"
  description = "Path to the SSH public key for accessing cloud instances. Used for creating AWS keypair."
}

variable "ssh_key_private" {
  default     = "~/.ssh/id_rsa"
  description = "Path to the SSH public key for accessing cloud instances. Used for creating AWS keypair."
}

variable "amis" {
  description = "AMIs by region"

  default = {
    us-east-1 = "ami-97785bed" # ubuntu 14.04 LTS
    us-east-2 = "ami-f63b1193" # ubuntu 14.04 LTS
    us-west-1 = "ami-824c4ee2" # ubuntu 14.04 LTS
    us-west-2 = "ami-f2d3638a" # ubuntu 14.04 LTS
  }
}

variable "vpc_cidr" {
  default = "10.2.0.0/16"
}

variable "vpc_name" {
  default = "kranthi vpc"
}

variable "IGW_name" {
  default = "kranthi IGW"
}

variable "key_name" {
  default = "Srinivas"
}

variable "public_subnet1_cidr" {
  default = "10.2.1.0/24"
}

variable "public_subnet2_cidr" {
  default = "10.2.2.0/24"
}

variable "public_subnet3_cidr" {
  default = "10.2.3.0/24"
}

variable "private_subnet_cidr" {
  default = "10.2.4.0/24"
}

variable "public_subnet1_name" {
  default = "k1"
}

variable "public_subnet2_name" {
  default = "k2"
}

variable "public_subnet3_name" {
  default = "k3"
}

variable "private_subnet_name" {
  default = "k4"
}

variable "Main_Routing_Table" {
  default = "Main Routing table"
}

variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type        = "list"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "environment" {
  default = "dev"
}

variable "instance_type" {
  type = "map"

  default = {
    # dev = "t2.nano"
    dev = "t2.micro"

    #prod = "t2.medium"
  }
}
