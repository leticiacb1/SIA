# -------------------------------------------
# Docs : https://developer.hashicorp.com/terraform/tutorials/configuration-language/sensitive-variables
# Exportar as variaveis desejadas - Exemplo
# $ export TF_VAR_AWS_ACCESS_KEY_ID="anaccesskey"
# $ export TF_VAR_AWS_SECRET_ACCESS_KEY="asecretkey"
# $ export TF_VAR_AWS_REGION="us-east-1
#--------------------------------------------

variable "AWS_REGION" {
  description = "Região utilizada pela AWS"
  type        = string

  default = "us-east-1" # North Virginia
}

variable "AWS_ACCESS_KEY_ID" {
  description = "Acess Key ID - Obtida via Dashboard"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Acess Secret Key - Obtida via Dashboard"
  type        = string
  sensitive   = true
}


# ----- Sistema operacional instalado nas instâncias
variable "ami" {
  description = "AMI"
  default     = "ami-007855ac798b5175e" // Ubuntu - Região us-east-1
}

# ----- "Tamanho" da instância
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

# ---- VPC - Avaliable Zone 
variable "aval_zone" {
  description = "Avaliable Zone , VPC"
  default     = "us-east-1a"
}