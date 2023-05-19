# -------------------------------------------
# Docs : https://registry.terraform.io/providers/hashicorp/aws/latest/docs
# Define AWS provider

# Organization folder Terraform : https://www.youtube.com/watch?v=etru_8t7Dyk&t=2176s
#--------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

# -------------------------------------------
# Docs : https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_credentials_access-keys.html
#        https://medium.com/@shanmorton/set-up-terraform-tf-and-aws-cli-build-a-simple-ec2-1643bcfcb6fe
#        https://aws.amazon.com/pt/blogs/aws-brasil/use-suas-credenciais-de-usuarios-iam-de-forma-mais-segura-com-infraestrutura-como-codigo/
#--------------------------------------------

provider "aws" {
  region     = var.AWS_REGION        # us-east-1
  access_key = var.AWS_ACCESS_KEY_ID # Após obter acess key no Dashboard da Amazon
  secret_key = var.AWS_SECRET_ACCESS_KEY

  default_tags {
    tags = {
      managed-by = "terraform"
    }
  }
}
