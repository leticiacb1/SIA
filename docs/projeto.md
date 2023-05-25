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

* **terraform init**

Inicializa o ambiente com o provider utilizado.

Por exemplo, se você estiver utilizando o provider "aws", inicializa o plugin para Amazon Web Services.

```bash
terraform init
```

* **terraform plan**

Mostra o plano de execução do terraform.

```bash
terraform plan
```

* **terraform apply**

Este comando que cria e altera as Instâncias/Objetos no Provider de acordo com o seu terraform.

```bash
terraform apply
```

* **terraform destroy**


```bash
terraform destroy
```

Este comando para as Instâncias/Objetos em execução e destruindo todos os recursos que foram criados durante o processo de criação.

* **terraform show**

Mostra um resumo do status da sua infraestrutura terraform.

```bash
terraform show
```

* **terraform fmt**

```bash
terraform fmt
```

Formata os arquivos `.tf`

* **terraform output**

Mostra valor das variáveis output.

```bash
terraform output
```

::: warning Dica
 
Caso não tenha familiaridade com a sintaxe do terraform, recomendo fortemente que assista o vídeo do canal [KodeKloud](https://www.youtube.com/watch?v=YcJ9IeukJL8&t=4818s) e faça os exercícios gratuitos fornecidos.

Indico também a leitura da [documentação oficial](https://developer.hashicorp.com/terraform/docs).

:::

## Iniciando o projeto

Crie uma pasta chamada `terraform`.

Os arquivos **terraform** possuem extensão `.tf` , que definem a infraestrutura.

O terraform possui um "arquivo de referência" do seu estado chamado `terraform.tfstate`. Por meio desse arquivo ele sabe o que deve ser implantado.

### Secret

Nesse arquivo, termos a definição dos valores sensíveis do projeto. 

*secret.tfvars*
```bash

AWS_REGION            = "us-east-1"
AWS_ACCESS_KEY_ID     = <Credemcial_acesso_AWS>
AWS_SECRET_ACCESS_KEY = <Credemcial_acesso_AWS>

```

::: danger Atenção
Os valores **AWS_ACCESS_KEY_ID** e **AWS_SECRET_ACCESS_KEY** são de extrema sensibilidade. Em hipótese alguma compartilher esse arquivo.
:::

### Variables

Nesse arquivo definiremos as variáveis utilizadas em todo o projeto.

Os demais arquivos podem acessar os valores declarados nesse arquivo por meio da sintaxe :

```bash
var.nome_variavel
```

*variables.tf*

```bash

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

variable "aval_zone_1" {
  description = "Avaliable Zone 1, VPC"
  default     = "us-east-1a"
}

variable "aval_zone_2" {
  description = "Avaliable Zone 2, VPC"
  default     = "us-east-1b"
}
```

### Definindo providers

Nesse arquivo definiremos os provedores que utilizaremos. Um provider nada mais é do que o provedor de serviços cloud que você irá utilizar em sua aplicação.

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

### Criando nossa VPC

Vamos agora criar nossa Virtual Private Cloud. Iremos analisar os códigos e seus parâmetros ao poucos.

```js{1}
resource "aws_vpc" "main-vpc" {

  cidr_block       = "192.168.0.0/16"
  
  # --- Código omitido ---
}

```




### Acessando a internet  | Internet gatway 


## Referências

*[1]*: O que é AWS CLI ?. Disponível [aqui](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
<br>