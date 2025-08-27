locals {
  eks_cluster_sg = data.aws_eks_cluster.eks-security-group.vpc_config[0].cluster_security_group_id
}

module "test-vpc-endpoints" {
    source = "./vpc-endpoints/"
    
    region             = var.region
    project            = var.project
    vpc_id             = aws_vpc.vpc.id
    subnet_ids         = aws_subnet.private-subnet[*].id
    service           = var.services
    route_table_ids    = aws_route_table.private-rt[*].id
    security_group_ids = [local.eks_cluster_sg]
}