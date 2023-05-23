# ------------------------------------------------
# Docs : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet 
# ------------------------------------------------

# --- Create Public Subnets ---

resource "aws_subnet" "subnet-public-1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.0.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_1

  # Required for EKS 
  # Qualquer intancia lançada nessa rede pública, recebe um IP de forma automática
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-${var.aval_zone_1}"

    # Required for EKS
    "kubernetes.io/cluster/eks" = "shared" # Permite que EKS descubra a subnet e a use 
    "kubernetes.io/role/elb"    = 1        # Necessário para public LoadBalance - Permiete que o EKS descurbra as subnets e posicione o lb.
  }

}


resource "aws_subnet" "subnet-public-2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.64.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_2

  map_public_ip_on_launch = true

  tags = {
    Name                        = "Public-${var.aval_zone_2}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }

}

# --- Create Private Subnets ---

resource "aws_subnet" "subnet-private-1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.128.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_1

  # Required for EKS 
  # Qualquer intancia lançada nessa rede privada, recebe um IP de forma automática
  map_public_ip_on_launch = true

  tags = {
    Name = "Private-${var.aval_zone_1}"

    # Required for EKS
    "kubernetes.io/cluster/eks" = "shared" # Permite que EKS descubra a subnet e a use 
    "kubernetes.io/role/internal-elb"    = 1        # Necessário para private LoadBalance lançados pelo EKS Cluster- Permiete que o EKS descurbra as subnets e posicione o lb.
  }

}

resource "aws_subnet" "subnet-private-2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.192.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_2

  map_public_ip_on_launch = true

  tags = {
    Name                        = "Private-${var.aval_zone_2}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/internal-elb"    = 1
  }

}