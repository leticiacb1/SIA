---
#sidebar: false
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

    Verifique se suas credenciais foram criadas de forma adequada:
  
  *Ubuntu/Debian*
  ```bash
  cat ~/.aws/credentials  
  ```

    Retorno esperado:

  <div align="center">
  <img src = "/img/credenciais_aws.jpeg" />
  </div>
  <br>

* Verifique as permissões do usuário IAM. 

  Seu usuário deve possuir as seguintes permissões: **AdministratorAccess** e **AmazonEKSClusterPolicy**. 
  
  Caso não saiba como adicionar permissões ao seu usuário, acesse [aqui](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/access_policies_manage-attach-detach.html).

* **Terraform** instalado e funcionando. 

* **Kubectl** instalado e funcionando. 

## Conceitos básicos | Terraform

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

*`secret.tfvars`*
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

*`variables.tf`*

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

*`provider.tf`*
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

*`vpc.tf`*
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

*`internet-gateway.tf`*
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

*`subnets.tf`*
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

*`subnets.tf`*
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

### Elastic IPs

Um endereço IP elástico é um endereço IPv4 estático projetado para computação em nuvem dinâmica.*[4]* 

Para exmeplificar imagine que você deseja entrar via SSH na sua instância EC2, para fazer isso via terminal você precisará o IPv4 da sua instância , esse IP foi dado a instância automaticamente após a sua criação. S e por algum motivo essa instância tenha sido interrompida (pausada/parada), ao retornar a atividade ela voltará com outro IPv4 e para comunicação SSH precisaremos específicar esse novo IP.

Utilizando o memso contexto, caso essa instância esteja com o Elastic IP configurado, ao retornar a atividade ela manterá o seu endereço IPv4.

*`elastic-ips.tf`*
```bash
resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat2" {
  depends_on = [aws_internet_gateway.main]
}
```

Vamos examinar um pouco o código que definimos acima:

* **Bloco `depends_on`** :  indica dependência de um recurso/módulo com o comportamento de outro recurso.

::: warning Lembrete
Atualize sua infraestrutura para verififcar as mudanças na AWS !
:::

Em `Dashboard > VPC > IPs elásticos` 

<div align="center">
<img src = "/img/terraform_ip_elastico.png" />
</div>

### NAT Gateways

Um gateway NAT é um serviço Network Address Translation (NAT). Você pode usar um gateway NAT para que as instâncias em uma sub-rede privada possam se conectar a serviços fora de sua VPC, mas os serviços externos não podem iniciar uma conexão com essas instâncias. *[5]*


*`nat-gateways.tf`*
```bash
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
```

::: warning Lembrete
Atualize sua infraestrutura para verififcar as mudanças na AWS !
:::

Em `Dashboard > VPC > Gateways NAT` 

<div align="center">
<img src = "/img/terraform_nat_gateways.png" />
</div>

### Route Tables

Uma tabela de rotas contém um conjunto de regras, chamadas de routes, que são usadas para determinar para onde o tráfego de rede de sua sub-rede ou gateway é direcionado. Simplificando, ela informa aos pacotes de rede qual caminho eles precisam seguir para chegar ao seu destino.*[6,7]*

* Cada sub-rede em seu VPC deve estar associada a uma tabela de roteamento, que controla o roteamento da sub-rede (tabela de roteamento de sub-rede). 

Cada rota da tabela especifica um destino e um alvo.Por exemplo, para permitir que a sub-rede acesse a Internet por meio de um gateway da Internet, adicione a seguinte rota à tabela de rotas de sub-rede:

| Destino       |      Alvo     | 
| ------------- | :-----------: | 
| 0.0.0.0/0     |     idw-id    | 

O destino da rota é 0.0.0.0/0, que representa todos os endereços IPv4. O alvo é o gateway da Internet que está conectado à sua VPC.

*`route-tables.tf`*
```bash
# Default  trial to internet gateway
resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main-vpc.id

  # Qualquer IP - main-route-table
  #         Para : internet-gateway da VPC

  route {
    cidr_block = "0.0.0.0/0"

    # Identificar a nossa VPC internet gateway
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}


# 2 routing tabels para NATs gateways

resource "aws_route_table" "private-1" {

  vpc_id = aws_vpc.main-vpc.id

  # Qualquer IP - main-route-table
  #         Para : internet-gateway da subnet-public-1

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gateway-1.id
  }

  tags = {
    Name = "private1-route-table"
  }
}

resource "aws_route_table" "private-2" {

  vpc_id = aws_vpc.main-vpc.id

  # Qualquer IP - main-route-table
  #         Para : internet-gateway da subnet-public-2

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gateway-2.id
  }

  tags = {
    Name = "private2-route-table"
  }
}
```

Agora recisamos realizar a associação entre as tabelas de rotas e suas respectivas subredes.

*`route-table-assocition.tf`*
```bash

# Associar as subnets publicas criadas com suas respectivas 
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
```

::: warning Lembrete
Atualize sua infraestrutura para verififcar as mudanças na AWS !
:::

Em `Dashboard > VPC > Tabelas de rotas` 

<div align="center">
<img src = "/img/terraform_route_table.png" />
</div>

###  Elastic Kubernetes Service
<br>

<div align="center">
<img src = "/img/funcionamento_eks.png" />
<caption> Funcionamento do EKS. Imagem retirada de [8] </caption>
</div>

O primeiro passo para a implementação do EKS que devemos realizar é permitir que o EKS Cluster possua a "função" de criar um recurso na AWS. 



*`eks.tf`*
```bash

resource "aws_iam_role" "eks-cluster" {

  name = "eks-cluster"

  # Políticas que garante permissão para essa entidade assumir o Role
  # Role que Amazon EKS vão utilizar para criar recurso AWS para os Clusters Kubernets
  # EKS poderá assumir o role
  assume_role_policy = "${file("9-eks-role-policy.json")}"
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {

  # ARN da política que queremos aplicar:
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  # Quem queremos que tenha essa política
  role = aws_iam_role.eks-cluster.name
}

# --- Código omitido ---

```
<br>

*`9-eks-role-policy.json`*
```json
{
    "Version" : "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

* **assume_role_policy** : Política que concede permissão a uma entidade para assumir a função. *[9]*

* **policy_arn** : ARN da política que queremos aplicar. *[9]*

* **role** : "Função" que queremos que tenha essa política.

Com as nova políticas configuradas, podemos implementar o módulo eks.


*`eks.tf`*
```bash

# --- Código omitido ---

resource "aws_eks_cluster" "eks" {
  name = "eks"

  # IAM role que permite que o Kubernets control interaja com AWS API , utilizando seus recursos
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {

    # Quremos que EKS crie um Endpoint Público
    endpoint_private_access = false
    endpoint_public_access  = true

    # Subnets que quero que esse cluster use . 
    # É necessário que exosta pelo menos 2 zonas diferentes configuradas
    subnet_ids = [
      aws_subnet.subnet-public-1.id,
      aws_subnet.subnet-public-2.id,
      aws_subnet.subnet-private-1.id,
      aws_subnet.subnet-private-2.id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy,
  ]
}
```
<br>

#### Nodes do EKS

Nesse ponto do tutorial possuimos o recurso EKS devidamente instanciado e com as permissões necessárias para atuar da forma que esperamos. Porém, ainda não fizemos nenhuma definição/configuração relacionada aos **workers**.

Antes de iniciarmos com mais código, verifique se nesse ponto do tutorial você possui os seguintes arquivos:

```
terraform/
├─ provider.tf
├─ vpc.tf
├─ internet-gateway.tf
├─ subnets.tf
├─ elastic-ips.tf
├─ nat-gateway.tf
├─ route-tables.tf
├─ route-table-association.tf
├─ eks.tf
├─ 9-eks-role-policy.json
├─ secret.tfvars
└─ variables.tf
```

Da mesma forma que precisamos das permissões para que o EKS tivesse acesso a determinadas funções, os seus **workers** também precisam de permissões, isso será implementado no código abaixo.

*`eks-node-group.tf`*

```bash

# ------- CREATE IAM Role for EKS Node Group
resource "aws_iam_role" "node-general" {
  
  name = "eks-node-group-general"
  
  assume_role_policy = "${file("11-eks-node-role-policy.json")}"
}

# -- Políticas necessárias para o correto funcionamento dos workers:

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  role = aws_iam_role.node-general.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-general.name
}

# Download private images from Ec2 repository
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-general.name
}

# --- Código omitido ---

```
<br>

*`11-eks-node-role-policy.json`*
```json
{
    "Version" : "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

Por fim , devemos definir as caracteríticas das instâncias EC2 que trabalham como os **workers** do nosso Cluster EKS.


*`eks-node-group.tf`*
```bash

# --- Código omitido ---

resource "aws_eks_node_group" "nodes-general-group" {

  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "Nodes-general-group"

  # Permissões para o EKS Nodes
  node_role_arn = aws_iam_role.node-general.arn

  # Identificar as EC2 Subnets para associar ao EKS-Node-Group
  # Essas subnets devem ter tags obrigatórias
  # Public-subnets serão apenas utilizadas pelo load-balancer,
  subnet_ids = [
    aws_subnet.subnet-private-1.id,
    aws_subnet.subnet-private-2.id,
  ]

  # Configuração de escalabilidade:
  scaling_config {
    desired_size = 2 #  Worker nodes desejados
    max_size     = 2 #  Maior número de works-nodes 
    min_size     = 2 #  Menor número de works-nodes 
  }

  # Type of AMAZON-Machine
  ami_type = "AL2_x86_64"

  # Type of Capacity
  capacity_type = "ON_DEMAND"

  # Disk size (GB) para os workers
  disk_size = 20

  force_update_version = false
  instance_types       = ["t3.small"]

  labels = {
    "role" = "nodes-general"
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
  ]
}
```

O código apresentado acima configura :

* As permissões que esses workers possuem.

* As subredes onde as instâncias deveram ser criadas (no caso desse projeto, as instâncias devem ser criadas apenas nas subredes privadas).

* Configuração de **escalabilidade** , permitindo que mais ou menos instâncias EC2 sejam criadas a depender da demanda. 

::: warning Atenção
Escolhi deixar o valor "fixo" de apenas 2 instâncias, para manter o formato do diagrama do projeto apresentado em [Entendendo o Projeto](./contextualizacao.md), mas alterando esses parâmetros conseguimos a criação de mais ou meno instância a depender da demanda.
:::

* Caracteristicas físicas (hardware) dessas instâncias.

::: warning Lembrete
Atualize sua infraestrutura para verififcar as mudanças na AWS !
:::

Em `Dashboard > EKS >  Cluster > cluster_name` 

<div align="center">
<img src = "/img/terraform_eks.png" />
</div>

<br>

#### Testando conexão

Nesse ponto do tutorial, você deve possuir os seguintes arquivos:

```
terraform/
├─ provider.tf
├─ vpc.tf
├─ internet-gateway.tf
├─ subnets.tf
├─ elastic-ips.tf
├─ nat-gateway.tf
├─ route-tables.tf
├─ route-table-association.tf
├─ eks.tf
├─ eks-role-policy.tf
├─ 9-eks-role-policy.json
├─ 11-eks-node-role-policy.json
├─ secret.tfvars
└─ variables.tf
```

Vamos obter as configurações do kubernets por meio do comando:

*Ubuntu/Debian*
```bash
aws eks --region <config_region> update-kubeconfig  --name <cluster_name> --porfile <aws_profile_credentials>
```

::: warning Para saber mais
Caso queira entender melhor sobre o arquivo kubeconfig , acesse [aqui](https://docs.aws.amazon.com/pt_br/eks/latest/userguide/create-kubeconfig.html)
:::

Resultado esperado:

<div align="center">
<img src = "/img/kubeconfig.jpeg" />
</div>

<br>

Podemos agora verificar o cluster EKS que criamos anteriormente.

*Ubuntu/Debian*
```bash
kubectl get svc
```

Resultado esperado:

<div align="center">
<img src = "/img/kubectl_get_svc.jpeg" />
</div>

## Subindo uma aplicação!

Vamos agora subir uma aplicação **NGINX** na infraestrutura que criamos !

Crie uma pasta chamada `app` no mesmo nível da pasta `terraform` que utilizamos até agora e crie os seguintes arquivos:

```
app/
├─ deployment.yml
└─ service.yml
terraform/
```

*`deployment.yml`*

```yml
# Docs : https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/
# Application
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.16.1 # Update the version of nginx from 1.14.2 to 1.16.1
        ports:
        - containerPort: 80
```

*`service.yml`*

```yml{7,8,9,23,24}
# --- Private Load Balance : Tax between subnets configured with tags
apiVersion: v1
kind: Service
metadata:
  name: internal-nginx-svc
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
    service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
    service.beta.kubernetes.io/aws-load-balancer-internal: 0.0.0.0/0  # To create private load balance , default = public
spec:
  ports:
  - port: 80
    protocol: TCP
  selector:
    app: nginx
  type: LoadBalancer
# --- Public Load Balance : Expose service - Acess by internet
apiVersion: v1
kind: Service
metadata:
  name: external-nginx-svc
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
    service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
spec:
  ports:
  - port: 80
    protocol: TCP
  selector:
    app: nginx
  type: LoadBalancer
```

O arquivo *`deployment.yml`* é o responsável por propriamente subir a aplicação **NGINX**.

O arquivo *`service.yml`* posiciona e configura os **load-balancers** nas subredes criadas. 

::: info Importante
Lembra das tags que implementamos no arquivo `subnets.tf` ? Nesse arquivo elas são fundamentais para a implementação dos **load-balancers** nos locais certo da nossa arquitetura.
:::

::: warning Atenção 
O kubernets está sendo o responsável pela criação dos **load balancers**. E após subirmos a aplicação é possível observar que os load balancers foram criados no Dashboard da Amazon (`Painel EC2 > Balanceamento de carga > Load balancers`). 
:::

O entendimento da construção dos arquivos **.yml** foge do objetivo desse tutorial, mas caso queira saber mais clique [aqui](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/) e [e aqui](https://codefresh.io/learn/software-deployment/kubernetes-deployment-yaml/) e [também aqui](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/).

Para subir a aplicação no container kubernets , rode:

```bash
kubectl apply -f <caminho_para_arquivo_deployment>

kubectl apply -f <caminho_para_arquivo_service>
```

Resultado esperado:

<div align="center">
<img src = "/img/deploy_app.jpeg" />
</div>

Verficando o status da aplicação que subimos:

```bash
kubectl get pods
```

Resultado esperado:

<div align="center">
<img src = "/img/get_pods.jpeg" />
</div>


```bash
kubectl get nodes
```
Resultado esperado:

<div align="center">
<img src = "/img/get_nodes.jpeg" />
</div>

```bash
kubectl get svc
```

Resultado esperado:

<div align="center">
<img src = "/img/get_svc.jpeg" />
</div>

#### Acessando a nossa aplicação

O resultado do comango **kubectl get svc** retorna um campo chamado  **EXTERNAL IP**. Conseguimos acessar nossa aplicação digitando em um navegador:

```
http://<EXTERNAL IP>
```
Resultado esperado:

<div align="center">
<img src = "/img/acessando_nginx.jpeg" />
</div>

## Limpando ambiente

Como reforçado anteriormente, o terraform não foi o responsávle pela criação dos load balancers da nossa
aplicação. Dessa forma, o terraform não possui a permissão para "deletar" serviços não configurados por ele.

Assim , antes de aplicarmos o comando para limpar o ambiente (**terraform destroy**) , devemos manualmente deletar os load_balancer criados no via Dashboard da Amazon.

Em `Painel EC2 > Balanceamento de carga > Load balancers`:

<div align="center">
<img src = "/img/deleta_load_balancers.png" />
</div>


Após isso podemos realizar a limpeza via terraform:

```
terraform destroy
```

## Referências

*[1]*: Configure instance tenancy with a launch configuration . Disponível [aqui](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-dedicated-instances.html)
<br>

*[2]*: Estabelecer conexão com a Internet usando um gateway da Internet . Disponível [aqui](https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/VPC_Internet_Gateway.html)
<br>

*[3]*: Regions and Zones . Disponível [aqui](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)
<br>

*[4]*: Elastic IP addresses. Disponível [aqui](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)

*[5]*: NAT gateways. Disponível [aqui](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html)

*[6]* Configure route tables. Disponível [aqui](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)

*[7]* AWS — VPC Route Table Overview. Disponível [aqui](https://medium.com/awesome-cloud/aws-vpc-route-table-overview-intro-getting-started-guide-5b5d65ec875f)

*[8]* How does Amazon EKS work? . Disponível [aqui](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)

*[9]* Resource: aws_iam_role . Disponível [aqui](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)

*[10]* : Tutorial de implementação NGINX no kubernets. Disponível [aqui](https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/)