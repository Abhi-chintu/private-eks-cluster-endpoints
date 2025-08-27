variable "region" {
    type = string  
}

variable "project" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "service" {
    type = list(object({
        name                = string
        type                = string
        private_dns_enabled = bool
    }))
}

variable "route_table_ids" {
    type = list(string)
}