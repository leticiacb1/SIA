---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "SIA"
  text: "Scalable infrastructure for applications"
  tagline : "Tutorial de criação de uma infraestrutura escalonável para aplicações na AWS"

  image:
    src: /img/background_home.gif
    alt: VitePress

  actions:
    - theme: brand
      text: Entendendo o projeto
      link: /contextualizacao
    - theme: alt
      text: SIA
      link: /primeiros-passos

features:
  
  - icon : 
      src: /img/terraform_icon.png
    title : Terraform
    details: O Terraform é uma ferramenta de software de infraestrutura como código de código aberto criada pela HashiCorp.
    link: https://developer.hashicorp.com/terraform/docs
    linkText: Docs
  - icon : 
      src: /img/kubernetes_icon.png   
    title: Kubernets
    details: O Kubernetes é um software de código aberto que permite implantar e gerenciar aplicações conteinerizadas em grande escala.
    link: https://kubernetes.io/docs/home/
    linkText: Docs

  - icon : 
      src: /img/aws_icon.png   
    title: AWS
    details: Plataforma de serviços de computação em nuvem, que formam uma plataforma de computação na nuvem oferecida pela Amazon.com.
    link: https://docs.aws.amazon.com/
    linkText: Docs
---

