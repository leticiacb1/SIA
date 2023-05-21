# ----- Configurando IP elástico

resource "aws_eip" "nat1" {

  # Depende diretamente da exitencia do internet-gateway
  depends_on = [aws_internet_gateway.main]

}

resource "aws_eip" "nat2" {
  depends_on = [aws_internet_gateway.main]
}