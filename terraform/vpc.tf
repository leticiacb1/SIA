# -------------------------------------------
# Docs : https://docs.aws.amazon.com/directoryservice/latest/admin-guide/gsg_create_vpc.html (Dashboard)
#        https://thecloudbootcamp.com/pt/blog/aws/criando-uma-instancia-ec2-utilizando-o-terraform/
#        https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
#        https://www.youtube.com/watch?v=KJYJj32PUbw
#        https://www.youtube.com/watch?v=OxxO58LtD8A&list=PL-cC6RUnFTfMlh1Cl6Mf8sbGApomjevS8&index=9
# Creditos aos canais https://www.youtube.com/@codeforall9837/featured e KodeKloud
# -------------------------------------------

# Internet VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/24"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Subnets
resource "aws_subnet" "vpc-public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/25" # Ip range
  map_public_ip_on_launch = true
  availability_zone       = var.aval_zone
  tags = {
    Name = "subnet_1"
  }
}

# -------------------------------------------
# Docs : https://www.youtube.com/watch?v=9ZMyfdbSwCg&list=PL-cC6RUnFTfMlh1Cl6Mf8sbGApomjevS8&index=12
#        https://www.youtube.com/watch?v=BKm5HDqZkNo&list=PL-cC6RUnFTfMlh1Cl6Mf8sbGApomjevS8&index=13
# -------------------------------------------
# ---- Internet gateway

resource "aws_internet_gateway" "gway" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "internet-gateway"
    } 
}

# Tabela de Rotas
resource "aws_route_table" "route-table" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "route-table"
    } 

}

# Trabalhando com IPV4
# Qualquer IP que quiser acessar a nossa rede, 
# vamos direcionar ao nosso gatway da internet
resource "aws_route" "route" {
    route_table_id = aws_route_table.route-table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gway.id
}


# Associação da subnet com a route-table o que habilita 
# o tráfico de rede e torna nossa subnet pública
resource "aws_route_table_association" "table" {
    subnet_id = aws_subnet.vpc-public-1.id
    route_table_id = aws_route_table.route-table.id
}
