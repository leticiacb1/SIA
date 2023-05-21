# -------------------------------
# Docs : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role
#        https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
# -------------------------------


# Role que será utilizado pelo EKS Cluster para criar recursos AWS

resource "aws_iam_role" "eks-cluster" {

  name = "eks-cluster"

  # Políticas que garante permissão para essa entidade assumir o Role
  # Role que Amazon EKS vão utilizar para criar recurso AWS para os Clusters Kubernets
  # EKS podera assumir o role
  assume_role_policy = "${file("9-eks-role-policy.json")}"
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {

  # ARN da política que queremos aplicar:
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  # O role que queremos que tenha essa política
  role = aws_iam_role.eks-cluster.name
}

# EKS

resource "aws_eks_cluster" "eks" {
  name = "eks"

  # IAM role que permite que o Kubernets control interaja com
  # AWS API , utilizando seus recursos
  role_arn = aws_iam_role.eks-cluster.arn

#   # Versão da Master desejada:
#   version = "1.18"

  vpc_config {

    # Quero que o EKS crie um Endpoint Público
    endpoint_private_access = false
    endpoint_public_access  = true

    # Subnets que quero que esse cluster use
    # É necessário haver pelo menos 2 zonas diferentes configuradas
    subnet_ids = [
      aws_subnet.subnet-public-1.id,
      aws_subnet.subnet-public-2.id,
      aws_subnet.subnet-private-1.id,
      aws_subnet.subnet-private-2.id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy,
  ]
}

output "endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}