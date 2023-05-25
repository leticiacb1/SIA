# Reagras que determinam para onde o tráfico de internet 
# (da sua subnet ou gateway) é direcionado

# Default  trial to internet gateway
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main-vpc.id

  # Qualquer IP - main-route-table
  #         Para : internet-gateway da VPC

  route {
    cidr_block = "0.0.0.0/0"

    # Identificar a nossa VPC internet gateway
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}


# 2 routing tabels for NATs gateways

resource "aws_route_table" "private-1" {

  vpc_id = aws_vpc.main-vpc.id

  # Qualquer IP - main-route-table
  #         Para : internet-gateway da subnet-public-1

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gateway-1.id
  }

  tags = {
    Name = "private1-route-table"
  }
}

resource "aws_route_table" "private-2" {

  vpc_id = aws_vpc.main-vpc.id

  # Qualquer IP - main-route-table
  #         Para : internet-gateway da subnet-public-2

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gateway-2.id
  }

  tags = {
    Name = "private2-route-table"
  }
}