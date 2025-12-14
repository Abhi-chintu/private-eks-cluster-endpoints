resource "aws_iam_role" "eks-cluster-role" {
  name = "${var.project}-eks-cluster-role"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks-nodegroup-role" {
  name = "${var.project}-eks-nodegroup-role"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  POLICY
}


resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks-nodegroup-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks-nodegroup-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks-nodegroup-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_cluster" "test-eks-cluster" {
  name     = "${var.project}-eks-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = aws_subnet.private-subnet[*].id
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy
  ]
  tags = {
    Name = "${var.project}-eks-cluster"
  }
}

data "aws_eks_cluster" "eks-security-group" {
  name       = aws_eks_cluster.test-eks-cluster.name
  depends_on = [aws_eks_cluster.test-eks-cluster]
}

resource "aws_security_group_rule" "eks_https_inbound" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = tolist([var.vpc_cidr])
  security_group_id = data.aws_eks_cluster.eks-security-group.vpc_config[0].cluster_security_group_id
}

resource "aws_eks_node_group" "aws_eks_node_group" {
  cluster_name    = aws_eks_cluster.test-eks-cluster.name
  node_group_name = "${var.project}-eks-node-group"
  node_role_arn   = aws_iam_role.eks-nodegroup-role.arn
  subnet_ids      = aws_subnet.private-subnet[*].id
  instance_types  = var.instance_types
  ami_type        = var.ami_type
  disk_size       = var.disk_size
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly
  ]
  tags = {
    Name = "${var.project}-eks-node-group"
  }
}

resource "aws_eks_addon" "addons" {
  for_each      = var.eks_addons
  cluster_name  = aws_eks_cluster.test-eks-cluster.name
  addon_name    = each.key
  addon_version = each.value

  depends_on = [aws_eks_cluster.test-eks-cluster,
  aws_eks_node_group.aws_eks_node_group]
}

