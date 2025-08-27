#VPC variables
region = "ap-south-1"
vpc_cidr = "10.0.0.0/16"
project = "test"
public_subnet_cidrs = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
private_subnet_cidrs = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
availability_zones = [ "ap-south-1a", "ap-south-1b", "ap-south-1c" ]
allow-to-internt = "0.0.0.0/0"

#VPC Endpoint related variables
services = [
    { name = "ec2", type = "Interface", private_dns_enabled = true },
    { name = "ssm", type = "Interface", private_dns_enabled = true },
    { name = "ssmmessages", type = "Interface", private_dns_enabled = true },
    { name = "ec2messages", type = "Interface", private_dns_enabled = true },
    { name = "logs", type = "Interface", private_dns_enabled = true },
    { name = "s3", type = "Gateway", private_dns_enabled = false },
    { name = "ecr.api", type = "Interface", private_dns_enabled = true },
    { name = "ecr.dkr", type = "Interface", private_dns_enabled = true },
    { name = "elasticloadbalancing", type = "Interface", private_dns_enabled = true },
    { name = "autoscaling", type = "Interface", private_dns_enabled = true }
]

#EKS related variables
eks_version = "1.32"
instance_types = [ "t3.medium" ]
disk_size = "20"
ami_type = "AL2_x86_64"
desired_size = 2
max_size = 2
min_size = 1

#EKS Addons
eks_addons = {
  vpc-cni           = "v1.18.0-eksbuild.1"
  coredns           = "v1.11.1-eksbuild.3"
  kube-proxy        = "v1.32.0-eksbuild.2"
  aws-ebs-csi-driver = "v1.30.0-eksbuild.1"
}