// Define an IAM role for the EKS cluster control plane
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-k8s"

  // Specify the permissions for assuming this role
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

// Attach AmazonEKSClusterPolicy to the IAM role created for EKS cluster
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

// Attach AmazonEKSServicePolicy to the IAM role created for EKS cluster
resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role = aws_iam_role.eks_cluster_role.name
}

// Define an IAM role for EKS worker nodes
resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group-k8s"

  // Specify the permissions for assuming this role
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

// Attach AmazonEKSWorkerNodePolicy to the IAM role created for EKS worker nodes
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

// Attach AmazonEKS_CNI_Policy to the IAM role created for EKS worker nodes
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

// Attach AmazonEC2ContainerRegistryReadOnly to the IAM role created for EKS worker nodes
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

# Create a Policy That Allows The eks:DescribeCluster Action
resource "aws_iam_policy" "eks_describe_cluster_policy" {
  name        = eks_describe_cluster_policy
  description = "Policy to allow describing EKS clusters"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "eks:DescribeCluster"
        Effect   = "Allow"
        Resource = "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${var.cluster_name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_describe_cluster_policy_attachment" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.eks_describe_cluster_policy.arn
}

// Define an IAM role for the EC2 Gateway to connect to the Cluster
resource "aws_iam_role" "gw_to_cluster" {
  name = "gateway-to-cluster"

  // Specify the permissions for assuming this role
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Policies For EC2 IAM Role

# Attach Policies 
resource "aws_iam_role_policy_attachment" "ec2_full_access" {
    role = aws_iam_role.ec2_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "ec2_read_only_access" {
    role = aws_iam_role.ec2_instance_role.name 
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# Create an Instance Profile (for attaching the role to an EC2 instance)
resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = var.ec2_instance_profile
    role = aws_iam_role.ec2_instance_role.name
}