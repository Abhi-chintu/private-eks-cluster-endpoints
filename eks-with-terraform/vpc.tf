resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.project}-vpc"
    }
}

resource "aws_subnet" "public-subnet" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.project}-public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "private-subnet" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.project}-private-subnet-${count.index + 1}"
    }
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.project}-igw"
    }
}

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.project}-public-rt"
    }
}

resource "aws_route" "allow-to-internet" {
    route_table_id = aws_route_table.public-rt.id
    destination_cidr_block = var.allow-to-internt
    gateway_id = aws_internet_gateway.igw.id
  
}
resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.project}-private-rt"
    }
}

resource "aws_route_table_association" "public-rt-association" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public-subnet[count.index].id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-rt-association" {
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.private-subnet[count.index].id
    route_table_id = aws_route_table.private-rt.id
}

