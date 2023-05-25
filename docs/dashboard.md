---
sidebar: false
hero: true
outline: deep
---

<VPDocHero
    class="VPDocHero VPDocHero-minimum"
    name="Dashboard AWS"
    text="Entendendo um pouco do seu funcionamento"
    image="img/aws.gif"
    :actions="[
        {
            theme: 'alt',
            text:'Clone o repositório',
            link:'https://github.com/leticiacb1/SIA/tree/main'
        },
    ]"
/>

# Dashboard

O presente tópico busca demonstrar como alguns pontos do projeto que poderiam ser realizados via Dashboard. O projeto não poderia ser reproduzido apenas por meio dessa interface gráfica, mas a visualização de alguns fluxos no Dashboard AWS ajudam no entendimento dos argumentos que o Terraform receberá, o que facilita o entendimento do seu código.

::: details Nota
Apesar de não obrigatório, achei interessante demonstrar um pouco do funcionamento dessa interface gráfica da **AWS** :) .
:::

## Criando uma VPC

Aqui , demonstrarei passo a passo como ocorre a criação de uma VPC no Dashboard.

* **1.** Dentro do Dashboard AWS busque pelo serviço VPC na barra de pesquisa.

<br>

<div align="center">
<img src = "/img/VPC_barra_pesquisa.png" />
<caption>Fluxo para criação da VPC - Parte 1</caption>
</div>
<br>

* **2.** Clique em *"Criar VPC"*.

<br>

<div align="center">
<img src = "/img/cria_VPC_1.png" />
<caption>Fluxo para criação da VPC - Parte 2</caption>
</div>
<br>

::: details Suas VPCs
Na opção *"Suas VPCs"* no menu lateral esquerdo é possível visualizar as VPCs já criadas.
:::


* **3.** Siga o "Passo a Passo" para a criação da sua VPC com as carcaterísticas de deseja.

<div align="center">
<img src = "/img/cria_VPC_2.png" />
</div>

<div align="center">
<img src = "/img/cria_VPC_3.png" />
<caption>Fluxo para criação da VPC - Parte 3</caption>
</div>

<br>

<div align="center">
<img src = "/img/cria_VPC_4.png" />
<caption>Visualização da tabela de Rotas e Subredes da VPC </caption>
</div>
<br>

:::  warning Lembrete
Por padrão a VPC já realiza a configuração de um internet gatway, assim como das respectivas tabelas de rotas. É possível realizar a verificação do **internet gatway** e da **tabela de rotas** criados no menu lateral esquerdo do painel da VPC.

Quando realizarmos essa configuração via **Terraform**, caberá a nós definir esses componentes.
::: 

## Criando instancias EC2

### Chaves de acesso

Antes da criação da nossa instancia EC2 é necessário a configuração de **chaves de acesso**.

As chaves de acesso são um conjunto de credenciais de seguranças usadas para provar a identidade ao tentarmos nos conectar a uma instancia EC2. Trata-se de um par de chaves, uma chave pública e uma chave privada, o Amazon EC2 armazena a chave pública na instância, e você armazena a chave privada. *[1]*

<div align="center">
<img src = "/img/cria_key_pair_1.png" />
<caption> Criação das chaves de acesso - Parte 1</caption>
</div>

<br>

<div align="center">
<img src = "/img/cria_key_pair_2.png" />
<caption> Criação das chaves de acesso - Parte 2</caption>
</div>
<br>

### Criando um grupo AutoScaling

O grupo Auto Scaling configura um conjunto de instâncias do EC2 para serem tratadas como um agrupamento lógico, buscando escalabilidade automática.O tamanho de um grupo do Auto Scaling depende do número de instâncias definidas como a capacidade desejada. É possível ajustar o tamanho do grupo para atender à demanda, manualmente ou usando a escalabilidade automática.*[2]*

<div align="center">
<img src = "/img/autoScaling_1.png" />
<caption> Criando grupo Auto Scaling para as instâncias  - Parte 1 </caption>
</div>

<br>

<div align="center">
<img src = "/img/autoScaling_2.png" />
<caption> Criando grupo Auto Scaling para as instâncias - Parte 2</caption>
</div>
<br>

<div align="center">
<img src = "/img/mecanismo_execucao.png" />
<caption> Criando um modelo de execução. Deve-se preencher os campos de acordo com as configurações desejadas. </caption>
</div>

<br>

<div align="center">
<img src = "/img/autoScaling_3.png" />
<caption> Criando grupo Auto Scaling para as instâncias - Parte 3</caption>
</div>

<br>

:::  warning Aviso
Ao clicar no **"Próximo"** indicado na última imagem vicê será levado para uma página de configuração do grupo AutoScaling , nele você deverá preencher campos importantes relacionados a como a escalabilidade nas instâncias deverá ocorrer.
Por motivos de praticidade (são muitos passos de configuração), não vou expor aqui o passo a passo dessa configuração.
::: 

### Security Group

"Um grupo de segurança atua como firewall virtual para as instâncias do EC2 visando controlar o tráfego de entrada e de saída. As regras de entrada controlam o tráfego de entrada para a instância e as regras de saída controlam o tráfego de saída da instância." *[3]*

* **1.** No "Painel do EC2" , busque por "Grupo de Segurança".Clique em "Criar grupo de Segurança".

<div align="center">
<img src = "/img/grupo_seguranca_1.png" />
<caption> Criando grupo de Segurança - Parte 1 </caption>
</div>

<br>

<div align="center">
<img src = "/img/grupo_seguranca_2.png" />
<caption> Criando grupo de Segurança - Parte 2 </caption>
</div>

:::  warning Cuidado
Para realizar a conexão com a instância via **SSH** é necessário que a instância possua as **regras de entrada** específicas ! 

Verifique também se a instância está sendo criada na VPC desejada!
::: 


### Criando uma instância

* **1.** Busque por **"EC2"** na barra de pesquisa.

<div align="center">
<img src = "/img/instancia_ec2_1.png" />
<caption> Criando uma instância - Parte 1 </caption>
</div>

<br>

* **2.** No menu lateral do Painel EC2 , clique em **"Instâncias"**. Nesse tópico, você conseguirá visualizar todas as suas instâncias em execução ou criar novas instâncias.

* **3.** Criar uma nova instância.

<div align="center" style="margin-right: 1.2rem">
<img src = "/img/instancia_ec2_2.png" />
</div>

<div align="center">
<img src = "/img/instancia_ec2_3.png" />
<caption> Criando uma instância - Parte 2</caption>
</div>

:::  warning Cuidado
O nosso próximo passo será o acesso da instância que criamos via SSH. Para isso é necessário que o **grupo de segurança** possua **"Regras de Entrada" para a conexão SSH!**
::: 

### Anexando o grupo AutoScaling a instância
<br>

<div align="center">
<img src = "/img/ConfiguraAutoScaling_1.png" />
<caption> Anexando AutoScaling - Parte 1 </caption>
</div>
<br>

<div align="center">
<img src = "/img/ConfiguraAutoScaling_2.png" />
<caption> Anexando AutoScaling - Parte 2 </caption>
</div>

### Testando conexão com a instância

* **1.** A conexão com a instância pode ser feita tanto por meio do Dashboard da AWS ou pelo seu terminal.

<div align="center">
<img src = "/img/ec2_ssh_5.png" />
<caption> Conexão com EC2  </caption>
</div>
<br>

<div align="center">
<img src = "/img/ec2_ssh_2.png" />
<caption> Conexão com EC2 utilizando o prório Dashboard </caption>
</div>
<br>

<div align="center">
<img src = "/img/ec2_ssh_3.png" />
<caption> Conexão com EC2 por meio do terminal local </caption>
</div>
<br>

<div align="center">
<img src = "/img/ec2_ssh_4.png" />
<caption> Conexão via SSH bem sucedida </caption>
</div>
<br>

## Criando um cluster EKS

### Dashboard AWS

* **1.**  Busque na barra de pesquisa por "EKS"

<div align="center">
<img src = "/img/criar_eks_0.png" />
<caption> Buscando pelo serviço EKS </caption>
</div>
<br>

* **2.** Clique em criar cluster. E siga o passo a passo para a criação do cluster com as especificações desejadas.

<div align="center">
<img src = "/img/criar_eks_1.png" />
<caption> Criar cluster eks - Parte 1</caption>
</div>
<br>

<div align="center">
<img src = "/img/criar_eks_2.png" />
<caption> Criar cluster eks - Parte 2 </caption>
</div>
<br>

<div align="center">
<img src = "/img/criar_eks_3.png" />
<caption> Criar cluster eks - Parte 3 </caption>
</div>
<br>


<div align="center">
<img src = "/img/criar_eks_4.png" />
<img src = "/img/criar_eks_5.png" />
<caption> Criar cluster eks - Parte 4 </caption>
</div>
<br>

:::  warning Cuidado
Ao criar seu cluster , se atente as **zonas de disponibilidade** , **subredes** e **VPC** escolhida.
::: 

### Conexão com o cluster

Para realizar um conexão é necessário registrar o cluster com o Amazon EKS e aplicar um arquivo manifesto YAML para habilitar a conectividade *[4]*.

Para realizar essa conexão o usuário IAM precisa de algumas permissões que podem ser melhor entendidadas nesse [link](https://docs.aws.amazon.com/pt_br/eks/latest/userguide/connector-grant-access.html).  

Por fugir um pouco do conteúdo que desejava apresentar aqui (breve introdução ao dashboard AWS), não irei demonstrar a conexão com o cluster, mas caso queira saber mais, pode seguir o próprio tutorial da AWS clicando nesse [link](https://docs.aws.amazon.com/pt_br/eks/latest/userguide/connecting-cluster.html).

## Referências

*[1]*: Pares de chaves do Amazon EC2 e instâncias do Linux . Disponível [aqui](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ec2-key-pairs.html).
<br>


*[2]*: Grupos do Auto Scaling . Disponível [aqui](https://docs.aws.amazon.com/pt_br/autoscaling/ec2/userguide/auto-scaling-groups.html).
<br>

*[3]*: Grupos de segurança do Amazon EC2 para instâncias do Linux. Disponível [aqui](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ec2-security-groups.html)

*[4]*: Conexão com um cluster. Disponível [aqui](https://docs.aws.amazon.com/pt_br/eks/latest/userguide/connecting-cluster.html)