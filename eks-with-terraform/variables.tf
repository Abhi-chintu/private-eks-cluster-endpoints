variable "region" {
    type = string
}

variable "project" {
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)  
}

variable "availability_zones" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "allow-to-internt" {
  type = string
}

#VPC Endpoint related variables
variable "services" {
    type = list(object({
        name                = string
        type                = string
        private_dns_enabled = bool
    }))
}

variable "eks_version" {
    type    = string
}

variable "instance_types" {
    type    = list(string)
}

variable "disk_size" {
  type = string
}

variable "ami_type" {
  type = string 
}

variable "eks_addons" {
  type = map(string)
}

variable "desired_size" {
  type = string
}

variable "max_size" {
  type = string
}

variable "min_size" {
  type = string
}

