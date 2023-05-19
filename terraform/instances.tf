# -------------------------------------------
# Docs : https://gmusumeci.medium.com/how-to-deploy-an-ubuntu-linux-ec2-instance-in-aws-using-terraform-330199d93dd8
#        O AWS Key Pair é um conjunto de credenciais de segurança que precisamos para nos conectar a uma instância do Amazon EC2.
#        O Amazon EC2 armazena a chave pública em nossa instância e nós armazenamos a chave privada. Para instâncias do Linux, 
#        a chave privada nos permite fazer SSH com segurança em nossa instância.

# Necessário para conexão via SSH nas instâncias
# ------------------------------------------

# ------------------------------------------
# Docs: https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key

# Cria chave privada e codifica no formato PEM
#--------------------------------------------

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Cria par de chave
resource "aws_key_pair" "key_pair" {
  key_name   = "ubuntu-key-pair"  
  public_key = tls_private_key.key_pair.public_key_openssh   # Chave pública
}

# Salva em um arquivo
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem        # Chave privada
}


# -------------------------------------------
# Docs : https://gmusumeci.medium.com/how-to-deploy-an-ubuntu-linux-ec2-instance-in-aws-using-terraform-330199d93dd8
#        https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
#        https://thecloudbootcamp.com/pt/blog/aws/criando-uma-instancia-ec2-utilizando-o-terraform/
#        https://youtu.be/5ryOTcWr5Wk
# ------------------------------------------

# Create EC2 Instance
resource "aws_instance" "ec2-instance" {
  ami                     = var.ami
  instance_type           = var.instance_type

  # VPC subnet
  subnet_id                   = aws_subnet.public-subnet.id
  
  vpc_security_group_ids      = [aws_security_group.aws-ubuntu-sg.id]
  #associate_public_ip_address = var.linux_associate_public_ip_address
  #source_dest_check           = false
  key_name                    = aws_key_pair.key_pair.key_name
  #user_data                   = file("aws-user-data.sh")
    
  tags = {
    Name = "ubuntu-vm"
  }
}