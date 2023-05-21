# Um NAT gatway em cada zona de disponibilidade - o que torna aplicação altamente disponível
# Se algo acontecer em uma zona de disponibilidade ainda teremos outro NAT gatway e as instancias ainda acessarama  internet

resource "aws_nat_gateway" "gateway-1" {

  # Aloca ELastic IP para o gateway
  # Tranforma private-IP-address em public-IP-address para conseguir Acesso a internet
  allocation_id = aws_eip.nat1.id

  # Public subnet que colocaremos o gateway
  subnet_id = aws_subnet.subnet-public-1.id

  tags = {
    Name = "NAT 1"
  }
}

resource "aws_nat_gateway" "gateway-2" {

  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.subnet-public-2.id

  tags = {
    Name = "NAT 2"
  }
}