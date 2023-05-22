
# ------------------------------------
# Docs : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
#        https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType
#        https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group
# ------------------------------------

# ------- CREATE IAM Role for EKS Node Group
resource "aws_iam_role" "node-general" {
  name = "eks-node-group-general"

  # A política que garante a entidade a permissão para assumir o "role"
  # Ec2 instances poderam assumir o Role 

  assume_role_policy = "${file("11-eks-node-role-policy.json")}"
#   assume_role_policy = <<POLICY
#   {

#   }
#   POLICY
}

# ------- 3 políticas

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {

  # ARN da política que queremos aplicar:
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  # O role que queremos que tenha essa política
  role = aws_iam_role.node-general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-general.name
}

# Download private images from Ec2 repository
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-general.name
}

# ------- Instance Group

resource "aws_eks_node_group" "nodes-general-group" {

  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "Nodes-general-group"

  # Permissões para o EKS Nodes
  node_role_arn = aws_iam_role.node-general.arn

  # Identificar as EC2 Subnets para associar ao EKS-Node-Group
  # Essas subnets devem ter tags obrigatórias
  # Public-subnets serão apenas utilizadas pelo load-balancer,
  subnet_ids = [
    aws_subnet.subnet-private-1.id,
    aws_subnet.subnet-private-2.id,
  ]

  # Configuração de escalabilidade:
  scaling_config {
    desired_size = 2 #  Worker nodes desejados
    max_size     = 2 #  Maior número de works-nodes 
    min_size     = 2 #  Menor número de works-nodes 
  }

  # Type of AMAZON-Machine
  ami_type = "AL2_x86_64"

  # Type of Capacity
  capacity_type = "ON_DEMAND"

  # Disk size (GB) para os workers
  disk_size = 20

  force_update_version = false
  instance_types       = ["t3.small"]

  labels = {
    "role" = "nodes-general"
  }

  # Kubernets version
  # version = "1.18"

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
  ]
}