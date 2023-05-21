# -------------------------------------------
# Docs : https://www.youtube.com/watch?v=9ZMyfdbSwCg&list=PL-cC6RUnFTfMlh1Cl6Mf8sbGApomjevS8&index=12
#        https://www.youtube.com/watch?v=BKm5HDqZkNo&list=PL-cC6RUnFTfMlh1Cl6Mf8sbGApomjevS8&index=13
# -------------------------------------------

# ---- Internet gateway
# Permite comunicação da nossa VPC com a internet

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-gateway"
  }
}