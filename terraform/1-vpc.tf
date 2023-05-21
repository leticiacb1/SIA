# -------------------------------------------
# Docs : https://docs.aws.amazon.com/directoryservice/latest/admin-guide/gsg_create_vpc.html (Dashboard)
#        https://thecloudbootcamp.com/pt/blog/aws/criando-uma-instancia-ec2-utilizando-o-terraform/
#        https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
#        https://www.youtube.com/watch?v=KJYJj32PUbw
#        https://www.youtube.com/watch?v=OxxO58LtD8A&list=PL-cC6RUnFTfMlh1Cl6Mf8sbGApomjevS8&index=9
# Creditos aos canais https://www.youtube.com/@codeforall9837/featured e KodeKloud
# -------------------------------------------

# VPC
resource "aws_vpc" "main-vpc" {

  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  # Requires for EKS
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Output VPC
# Útil para quando trabalhamos com módulos
output "vpc_id" {
  value       = aws_vpc.main-vpc.id
  description = "VPC id"
}

# -------------------------------------------
# Docs : https://www.youtube.com/watch?v=9ZMyfdbSwCg&list=PL-cC6RUnFTfMlh1Cl6Mf8sbGApomjevS8&index=12
#        https://www.youtube.com/watch?v=BKm5HDqZkNo&list=PL-cC6RUnFTfMlh1Cl6Mf8sbGApomjevS8&index=13
# -------------------------------------------
# ---- Internet gateway
