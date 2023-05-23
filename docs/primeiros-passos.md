---
sidebar: false
hero: true
outline: deep
---

<VPDocHero
    class="VPDocHero VPDocHero-minimum"
    name="Primeiros Passos"
    text="Configurações e instalações"
    image="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Travel%20and%20places/Flying%20Saucer.png"
    :actions="[
        {
            theme: 'alt',
            text:'Clone o repositório',
            link:'https://github.com/leticiacb1/SIA/tree/main'
        },
    ]"
/>

# Primeiros Passos

Nesta página, serão descritas as configurações e instalações necessárias para a reprodução do projeto.

### Pré-requisitos

Para a reprodução desse projeto é necessário que o usuário possua **conta na AWS com acesso ao console**. 

::: details Permissões
O usuário IAM deve possuir as seguintes permissões : **AdministratorAcess** e **AmazonEKSClusterPolicy**. Para saber mais, clique [aqui](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-attach-detach.html).
:::

### Instalações

* **AWS Command Line Interface (AWS CLI)** é uma ferramenta que permite o gerenciamento de seus produtos da AWS, através dele é possível controlar vários produtos/serviços da AWS pela linha de comando. Utilizaremos ele para enviar comandos ao nosso Cluster Kubernets.

*Ubuntu/Debian*
```bash
$ sudo apt install awscli
```

::: details Mais
Para instalar o AWS CLI no **Windows** ou **macOS** , acesse o [aqui](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
:::

* **Kubectl** é uma ferramenta de linha de comando que você usa para se comunicar com o servidor da API Kubernetes.

*Ubuntu/Debian*
```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.17/2023-05-11/bin/linux/amd64/kubectl

chmod +x ./kubectl

mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

kubectl version --short --client
```

::: details Mais
Para instalar o kubectl no **Windows** ou **macOS** , acesse o [aqui](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html).
:::

::: warning Cuidado
Para o correto funcionamento do **kubectl** , instale uma versão menor ou igual a 1.23. Caso queira saber mais, acesse [aqui](https://github.com/aws/aws-cli/issues/6920)
:::

* **Terraform** cria e gerencia recursos em plataformas de nuvem por meio de suas interfaces de programação de aplicativos (APIs). Para saber mais, acesse [aqui](https://developer.hashicorp.com/terraform/intro).


*Ubuntu/Debian*
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform
```

::: details Mais
Para instalar o Terraform no **Windows** ou **macOS** , acesse o [aqui](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
:::


**Input**

````
```js{4}
export default {
  data () {
    return {
      msg: 'Highlighted!'
    }
  }
}
```
````

**Output**

```js{4}
export default {
  data () {
    return {
      msg: 'Highlighted!'
    }
  }
}
```

## Custom Containers

**Input**

```md
::: info
This is an info box.
:::

::: tip
This is a tip.
:::

::: warning
This is a warning.
:::

::: danger
This is a dangerous warning.
:::

::: details
This is a details block.
:::
```

**Output**

::: info
This is an info box.
:::

::: tip
This is a tip.
:::

::: warning
This is a warning.
:::

::: danger
This is a dangerous warning.
:::

::: details
This is a details block.
:::

## More

Check out the documentation for the [full list of markdown extensions](https://vitepress.dev/guide/markdown).
