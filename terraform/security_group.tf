# -------------------------------------------
# Docs : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
#        https://gmusumeci.medium.com/how-to-deploy-an-ubuntu-linux-ec2-instance-in-aws-using-terraform-330199d93dd8
# Define grupo de segurança que será usado pelas instancias

# Define the security group - Ubuntu Instances
#--------------------------------------------

resource "aws_security_group" "aws-ubuntu-sg" {
  name        = "ubuntu-sg"
  description = "Allow incoming traffic to the Ubuntu EC2 Instance"
  #vpc_id      = aws_vpc.vpc.id
  
  # --- Permissões de ingresso : Permite conexões HTTP e SSH
  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }

  # SHH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }

  # --- Permissões de saída:
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  tags = {
    Name = "ec2_ssh_e_http"
  }
}