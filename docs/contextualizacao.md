---
outline: deep
---

# Entendendo o projeto

Nessa página será explicado melhor qual arquitetura foi utilizada para o desenvolvimento do projeto, assim como também a descrição de sua utilidade e de alguns conceitos prévios necessários para o entendimento dessa arquitetura.

## Descrição do projeto

Criação de uma Infraestrutura capaz de armazenar aplicações de forma escalonável.
Objetiva-se portanto o escalonamento automático de instâncias , a depender da necessiade computacional requerida pela aplicação, hospedando conteiners Docker orquestrados pelo Kubernets.

### Diagrama Arquitetura

<img src="/img/diagrama.jpeg" alt="Diagrama da Arquitetura" style="height: 50rem; width:40rem;"/>

### Conceitos básicos - Serviços AWS
<br>

####  Virtual Private Cloud (VPC) 

É um serviço da AWS que permite iniciar recursos da AWS em uma rede virtual isolada logicamente definida por você. Você tem controle total sobre seu ambiente de redes virtuais, incluindo a seleção do seu próprio intervalo de endereços IP, a criação de sub-redes e a configuração de tabelas de rotas e gateways de rede. *[1]*
<br>

#### Elastic Load Balance (ELB) 

É um serviço da AWS que distribui automaticamente o tráfego de entrada entre vários destinos, como instâncias do EC2, contêineres e endereços IP, em uma ou mais zonas de disponibilidade. O ELB automaticamente a capacidade do balanceador de carga em resposta a mudanças no tráfego de entrada. *[2]*

Por distribuir a carga de trabalho entre vários recursos computacionais, como servidores virtuais, o Load Balance aumenta a disponibilidade e a tolerância a falhas dos aplicativos (caso uma instancia esteja muito sobrecarregada, divide essa carga de trabalho com outra que não está com muita demanda). *[2]*

#### Amazon Elastic Compute Cloud (EC2)

O Amazon Elastic Compute Cloud (Amazon EC2) oferece uma capacidade de computação escalável na Nuvem da Amazon Web Services (AWS). O uso do Amazon EC2 elimina a necessidade de investir em hardware inicialmente, portanto, você pode desenvolver e implantar aplicativos com mais rapidez. É possível usar o Amazon EC2 para executar quantos servidores virtuais forem necessários, configurar a segurança e as redes e gerenciar o armazenamento. *[3]*

O Amazon EC2 permite aumentar ou reduzir a escala para lidar com alterações nos requisitos ou com picos em popularidade, utilizando  Auto Scaling. Isso permite a manutenção de disponibilidade do aplicativo e permite adicionar ou remover automaticamente instâncias do EC2 usando políticas de escalabilidade, essas políticas permitem adicionar ou remover a capacidade da instância do EC2 para atender a padrões de demanda estabelecidos ou em tempo real. *[3]*

## Refrências

[1]: Recursos do Amazon Virtual Private Cloud. Disponível [aqui](https://aws.amazon.com/pt/vpc/features/).
<br>

[2]: O que é Elastic Load Balance?. Disponível [aqui](https://docs.aws.amazon.com/pt_br/elasticloadbalancing/latest/userguide/what-is-load-balancing.html).
<br>

[3]: O que é o Amazon EC2? . Disponível [aqui](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/concepts.html)