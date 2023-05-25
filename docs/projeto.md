---
sidebar: false
hero: true
outline: deep
---

<VPDocHero
    class="VPDocHero VPDocHero-minimum"
    name="O Projeto"
    text="Configurando uma infraestrutura escalável para hospedagem de aplicações"
    image="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Travel%20and%20places/Rocket.png"
    :actions="[
        {
            theme: 'alt',
            text:'Clone o repositório',
            link:'https://github.com/leticiacb1/SIA/tree/main'
        },
    ]"
/>

## Configurações

* **AWS CLI** instalado e funcionando. 
    
    Realize a configuração de acesso no AWS CLI.

```bash
    aws configure
```

Será pedido valores de input do usuário, preencha como o indicado a seguir:

```bash
AWS_REGION            = "us-east-1"
AWS_ACCESS_KEY_ID     = <Credenciais_de_acesso_AWS>
AWS_SECRET_ACCESS_KEY = <Credenciais_de_acesso_AWS>
```

* Verifique as permissões do usuário IAM. 

  Seu usuário deve possuir as seguintes permissões: **AdministratorAccess** e **AmazonEKSClusterPolicy**. 
  
  Caso não saiba como adicionar permissões ao seu usuário, acesse [aqui](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/access_policies_manage-attach-detach.html).

* **Terraform** instalado e funcionando. 

* **Kubectl** instalado e funcionando. 

## Comandos básicos Terraform

## Iniciando o projeto

Cria uma pasta chamada `terraform`.

Os arquivos **terraform** possuem extensão `.tf` , que definem a infraestrutura.

O terraform possui um "arquivo de referência" do seu estado chamado `terraform.tfstate`. Por meio desse arquivo ele sabe o que deve ser implantado.

### Secret

### Provider

O primeiro arquivo que vamos implementar é o `provider.tf`. Nesse arquivo definiremos os provedores que utilizaremos. Um provider nada mais é do que o provedor de serviços cloud que você irá utilizar em sua aplicação.

*Provider.tf*
```bash

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

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

provider "kubernetes" {
    host = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64encode(aws_eks_cluster.eks.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks.name]
      command     = "aws"
    }

}

```

## Referências

*[1]*: O que é AWS CLI ?. Disponível [aqui](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
<br>