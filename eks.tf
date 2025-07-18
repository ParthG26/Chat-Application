resource "aws_iam_role" "demo-eks-cluster-role" {
name = "Terraform-EKS-Cluster-Role"
assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
        Action = [
        "sts:AssumeRole",
        ]
        Effect = "Allow"
        Principal = {
        Service = "eks.amazonaws.com"

        }
    },
    ]
})
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
role       = aws_iam_role.demo-eks-cluster-role.name
}

resource "aws_eks_cluster" "demo-eks-cluster" {
    name = var.cluster_name
    role_arn = aws_iam_role.demo-eks-cluster-role.arn
    vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = [
        aws_subnet.subnets["Public1"].id,
        aws_subnet.subnets["Public2"].id,
        aws_subnet.subnets["Private1"].id,
        aws_subnet.subnets["Private2"].id
    ]
    }
    access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
    }
    bootstrap_self_managed_addons = true
    tags = var.tags
    version = var.eks_version
    upgrade_policy {
    support_type = "STANDARD"
    }
    depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
}
