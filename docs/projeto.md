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

## Conceitos básicos Terraform

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

Este comando para as Instâncias/Objetos em execução e destruindo todos os recursos que foram criados durante o processo de criação.

```bash
terraform destroy
```
* **terraform show**

Mostra um resumo do status da sua infraestrutura terraform.

```bash
terraform show
```

* **terraform fmt**

Formata os arquivos `.tf`

```bash
terraform fmt
```

* **terraform output**

Mostra valor das variáveis output.

```bash
terraform output
```

De forma geral , podemos deifnir o formato para a declaração dos blocos de recurso de forma simplificada como o indicado na imagem abaixo.

<div align="center">
<img src = "/img/bloco_terraform_definicao.png" />
</div>

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

```bash{1}
resource "aws_vpc" "main-vpc" {

  # --- Código omitido ---
}

```

O resource **aws_vpc** permite que utilizemos do recurso VPC da AWS.

```bash{3,4}
resource "aws_vpc" "main-vpc" {
  
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  # --- Código omitido ---
}

```

* **CIRD (Encaminhamento Entre Domínios Sem Classificação)** :  um método de alocação de endereços IP que melhora a eficiência do encaminhamento de dados na Internet. Um bloco de CIDR é uma coleção de endereços IP que compartilham o mesmo prefixo de rede e número de bits. Para saber mais , acesse [aqui](https://aws.amazon.com/pt/what-is/cidr/#:~:text=o%20CIDR%20funciona.-,Blocos%20de%20CIDR,IP%20e%20um%20pequeno%20sufixo.).

* **instance_tenancy** : Define como as instâncias do EC2 são distribuídas pelo hardware físico. *[1]*

```bash{7,8}
resource "aws_vpc" "main-vpc" {

  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  # Requires for EKS
  enable_dns_support   = true
  enable_dns_hostnames = true

  # --- Código omitido ---
}
```

Os atributos em destaque (**enable_dns_support** e **enable_dns_hostnames**) são requeridos para o correto funcionamento da VPC com o EKS. 

Para mais informações, acesse [aqui](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html).

Por fim , podemos definir o arquivo `vpc.tf`:

*vpc.tf*
```bash
# VPC
resource "aws_vpc" "main-vpc" {

  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  # Requires for EKS
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Output VPC
# Útil para quando trabalhamos com módulos
output "vpc_id" {
  value       = aws_vpc.main-vpc.id
  description = "VPC id"
}

```

O atributo Tags é opcional, mas é fundamental para a organização dos componentes da nossa infraestrutura.

O bloco de nome **output** permite que tenhamos acesso a informação id da VPC "printada" no terminal pós "aplicação" do terraform. 

Até essa parte do tutorial, esperamos que possua os seguintes arquivos:

```
terraform/
├─ provider.tf
├─ vpc.tf
├─ secret.tfvars
└─ variables.tf
```

Nesse ponto, podemos dar o nosso primeiros comando terraform e verificar se a nossa VPC foi criada no Dashboard da AWS.

```bash
    terraform init
```
```bash
    terraform fmt
```
```bash
     terraform plan -var-file="secret.tfvars"
```
```bash
     terraform apply -var-file="secret.tfvars"
```

Após a aplicação desses comandos, espera-se que seu `Dashboard > VPC > Suas VPCs` esteja como o indicado abaixo:

<div align="center">
<img src = "/img/terraform_vpc.png" />
</div>


::: info INFO
A flag **"var-file"** indica que o arquivo **"secret.tfvars"** deve servir como um "input" do usuário para execução do comando.

Essa flag não é obrigatória, caso não seja passada serão pedidas inputs no terminal para o usuário.
:::

::: warning Para entender melhor

Veja novamente o tópico [Dashboard AWS- Criando uma VPC](./dashboard) e procure relações entre as variáveis configurdas no terraform e o passo a passo para configurar a VPC no Dashboard AWS.
:::

### Acessando a internet  | Internet gatway 

O **Internet gatway** é um componente da VPC  redundante e altamente disponível que permite a comunicação entre a VPC e a Internet. *[2]* 

*internet-gateway.tf*
```bash
resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-gateway"
  }
}
```

O único argumento obrigatório desse recurso é o ID da VPC. Esse argumento indica "em qual VPC esse componente dará acesso a internet".

### Subredes

Como é possível ver no diagrama do projeto indicado anteriomente, queremos que nossa VPC possua um total de **4 subrede** , sendo 2 públicas e 2 privadas e **2 Zonas de Disponibilidade**.

O conceito de subrede publica e privada ficará mais claramente definida adiante.

*subnets.tf*
```bash{19,22,39,40}
# --- Create Public Subnets ---

resource "aws_subnet" "subnet-public-1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.0.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_1

  # Required for EKS 
  # Qualquer intancia lançada nessa rede pública, recebe um IP de forma automática
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-${var.aval_zone_1}"

    # ------ Required for EKS ------
    # Permite que EKS descubra a subrede e a use 
    "kubernetes.io/cluster/eks" = "shared" 
    
    # Necessário para public LoadBalance - Permite que o EKS descubra a subrede e posicione o lb externo para o fluxo de serviços.
    "kubernetes.io/role/elb"    = 1        
  }

}


resource "aws_subnet" "subnet-public-2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.64.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_2

  map_public_ip_on_launch = true

  tags = {
    Name                        = "Public-${var.aval_zone_2}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }

  # --- Código omitido ---   
}
```

Vamos descrever um pouco alguns dos atributos utilizados no código acima:

* **vpc_id** : identificação da VPC na qual as subnets serão criadas.

* **availability_zone** : as zonas de disponibilidade são vários locais isolados em cada região. As zonas locais fornecem a capacidade de colocar recursos, como computação e armazenamento, em vários locais mais próximos de seus usuários finais. *[3]*

* **map_public_ip_on_launch** : quando `True` as instâncias executadas na sub-rede devem receber um endereço IP público.

Os tópicos destacados no código serão melhor entendidos adiante, mas de forma geral podemos definir que :

*  `"kubernetes.io/cluster/eks" = "shared"` : permitira que que o EKS descubra a subrede e a use.

*  `"kubernetes.io/role/elb" = 1` : Permite que o EKS descubra a subrede e posicioneum load balancer externo, necessário para o fluxo de serviços. 

Podemos completar o código adicionando também as subredes privadas.

*subnets.tf*
```bash{60,77}
# --- Create Public Subnets ---

resource "aws_subnet" "subnet-public-1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.0.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_1

  # Required for EKS 
  # Qualquer intancia lançada nessa rede pública, recebe um IP de forma automática
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-${var.aval_zone_1}"

    # Required for EKS
    "kubernetes.io/cluster/eks" = "shared" # Permite que EKS descubra a subnet e a use 
    "kubernetes.io/role/elb"    = 1        # Necessário para public LoadBalance - Permite que o EKS descurbra as subredes e posicione o lb.
  }

}


resource "aws_subnet" "subnet-public-2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.64.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_2

  map_public_ip_on_launch = true

  tags = {
    Name                        = "Public-${var.aval_zone_2}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }

}

# --- Create Private Subnets ---

resource "aws_subnet" "subnet-private-1" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.128.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_1

  # Required for EKS 
  # Qualquer intancia lançada nessa rede privada, recebe um IP de forma automática
  map_public_ip_on_launch = true

  tags = {
    Name = "Private-${var.aval_zone_1}"

    # Required for EKS
    "kubernetes.io/cluster/eks" = "shared" # Permite que EKS descubra a subnet e a use 
    "kubernetes.io/role/internal-elb"    = 1        # Necessário para private LoadBalance lançados pelo EKS Cluster- Permite que o EKS descurbra as subredes e posicione o lb.
  }

}

resource "aws_subnet" "subnet-private-2" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "192.168.192.0/18"

  # AZ subnet
  availability_zone = var.aval_zone_2

  map_public_ip_on_launch = true

  tags = {
    Name                        = "Private-${var.aval_zone_2}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/internal-elb"    = 1
  }

}
```

Os tópicos em destaque nesse arquivo também ficaram claros mais adiante no tutorial. Mas podemos definir que :

* `"kubernetes.io/role/internalelb" = 1` : Permite que o EKS descubra a subrede e posicione um load balancer interno, necessário para o fluxo de serviços. 

Nesse ponto, sua pasta deve possuir os seguintes arquivos:

```
terraform/
├─ provider.tf
├─ vpc.tf
├─ internet-gateway.tf
├─ subnets.tf
├─ secret.tfvars
└─ variables.tf
```

Vamos atualizar nossa infraestrutura e verificar se o **internet-gateway** e **subnets** foram criadas no Dashboard da AWS.

```bash
    terraform fmt
```
```bash
     terraform plan -var-file="secret.tfvars"
```
```bash
     terraform apply -var-file="secret.tfvars"
```

Após a aplicação desses comandos, espera-se as seguintes mudanças:

Em `Dashboard > VPC > Sub-redes` 

<div align="center">
<img src = "/img/terraform_subredes.png" />
</div>

Em `Dashboard > VPC > Gateways de Internet` 

<div align="center">
<img src = "/img/terraform_internet_gateway.png" />
</div>

## Referências

*[1]*: Configure instance tenancy with a launch configuration . Disponível [aqui](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-dedicated-instances.html)
<br>

*[2]*: Estabelecer conexão com a Internet usando um gateway da Internet . Disponível [aqui](https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/VPC_Internet_Gateway.html)
<br>

*[3]*: Regions and Zones . Disponível [aqui](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)
<br>