variable "access_key" {
     description = "AWS console Access key"
}

variable "secret_key" {
     description = "AWS console Secret key"
}

variable "region" {
     default     = "eu-central-1"
     type        = string
     description = "VPC Region"
}

variable "availability_zones" {
     default     = ["eu-central-1a", "eu-central-1b"]
     type        = list
     description = "Two Availability Zones"
}

variable "dns_support" {
    default = true
}

variable "dns_hostnames" {
    default = true
}

variable "instance_ten" {
    default = "default"
}

variable "cidr_block" {
    default = "10.0.0.0/16"
}

variable "pub_cidr_block" {
    default = "192.168.0.0/16"
}

variable "subnet_cidr" {
    default     = ["10.0.0.0/17", "10.0.128.0/17"]
    type        = list
    description = "List of private subnet CIDR block"
}

variable "public_subnet_cidr" {
    default     = "192.168.0.0/24"
    type        = string
    description = "Public CIDR subnet"
}

variable "public_rt_cidr" {
    default     = "0.0.0.0/0"
    type        = string
    description = "CIDR for the public route table"
}

variable "subnet_public_ip" {
    default     = true
    type        = bool
    description = "Assign public IP to the instance launched into the subnet"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "ec2_ami" {
    default = "ami-0767046d1677be5a0"
}
