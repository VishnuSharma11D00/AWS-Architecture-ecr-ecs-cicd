
variable "vpc_cidr_block" {
  description = "cidr block for VPC"
  default = "10.0.0.0/16"
}

variable "availability_zone1" {
  description = "Availability zone 1"
  default = "us-east-1a"
}

variable "availability_zone2" {
  description = "Availability zone 2"
  default = "us-east-1b"
}

variable "pubsub1_cidr" {
  description = "cidr block for public subnet in Availability zone 1"
  default = "10.0.1.0/24"
}

variable "pubsub2_cidr" {
    description = "cidr block for public subnet in Availability zone 2"
    default = "10.0.2.0/24"
}

variable "prisub1_cidr" {
  description = "cidr block for private subnet in Availability zone 1"
  default = "10.0.3.0/24"
}

variable "prisub2_cidr" {
  description = "cidr block for private subnet in Availability zone 2"
  default = "10.0.4.0/24"
}


