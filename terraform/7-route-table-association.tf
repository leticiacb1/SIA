
# Associar as subnets publicas criadas com suas respectivas 
# routing-tables


# ---- Public Routeing Table ----
resource "aws_route_table_association" "public-1" {

  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public-2" {

  subnet_id      = aws_subnet.subnet-public-2.id
  route_table_id = aws_route_table.public.id

}

# ---- Private Routeing Table ----

resource "aws_route_table_association" "private-1" {

  subnet_id      = aws_subnet.subnet-private-1.id
  route_table_id = aws_route_table.private-1.id

}

resource "aws_route_table_association" "private-2" {

  subnet_id      = aws_subnet.subnet-private-2.id
  route_table_id = aws_route_table.private-2.id

}