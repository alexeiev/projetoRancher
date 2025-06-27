# Laboratório de Rancher

Para facilitar o estudo e conhecer um pouco mais sobre a ferramenta Rancher, criei este projeto onde será possível fazer a instalação da infraestrutura com terraform, aprovisionamento do rancher com ansible-core e para facilitar estas execuções, um bom e velho Makefile.

## Dependencias
Para este projeto, utilizaremos 3 software que precisaremos instalar no nosso host.
* ansible-core
* terraform
* make

**OBS.: Para instalar o Terraform, seguir para a documentação oficial.** [Hashicorp - Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


## Infraestrutura - Terraform.

  * Para este projeto, utilizei um módulo que já tinha criado e esta disponível para também utilizarem no seu laboratório (proxmox) ou ambiente produtivo, como queiram.

### Conhecendo o módulo para proxmox
 * Escrevi um módulo para facilitar a criação/gestão de maquinas virtuais no proxmox.
 * Podem utilizar este módulo sempre que quiserem, e podem solicitar novas funcionalidades.
 * Deixo aqui o Link para conhecerem e deixarem seu star, e fazerem o fork...
 * [ ⭐ proxmox_module](https://github.com/alexeiev/proxmox_module)


### Conhecendo o arquivo do terraform. ./infra/create_lab.tf

```text
  vm_template       = "ubuntu-2404-v20250616"           # Informar o nome do template ubuntu para o uso
  site              = "proxmox.home.lab"                # FQDN ou ip do site
  srv_target_node   = "pv01"                            # Nó onde irá correr suas VMs
  vm_qnt            = 4                                 # Quantidade de VMs que o terraform irá aprovisionar
  vm_name           = "k8s-lab-0"                       # Nome da VM. Quando vm_qnt é maior que 1, o módulo faz o incremento do valor. Ex. lab-0 = lab-01, lab-02...
  vm_id             = 501                               # ID para a VM. Igual ao ponto anterior, também incrementa os números.
  vm_memory         = 4096                              # Memória em MB
  vm_cpu            = 4                                 # CPU
  vm_disk           = 60                                # Disco em GB
  vm_storage        = "nfs_dellmini2"                   # Indicar nome do seu storage. (local-lvm, nfs,...)
  vm_storage_type   = "qcow2"                           # Formato do HD. (qcow2, raw,...)
  net               = "vmbr0"                           # Interface de rede a ser utilizada
  net_vlan          = 15                                # Se usar VLAN, pode indicar aqui. Caso Contrário podes comentar a linha ou o valor 0
  vm_ip_address     = [                       
                      "ip=10.0.0.101/24,gw=10.0.0.1",   # Aqui é esperado uma lista com os valores de Ips státicos
                      "ip=10.0.0.102/24,gw=10.0.0.1",   # Este formato com "ip=x.x.x.x/24,gw=x.x.x.y" é esperado.
                      "ip=10.0.0.103/24,gw=10.0.0.1", 
                      "ip=10.0.0.104/24,gw=10.0.0.1",
                    ]
  username-so       = "ubuntu"                          # Usuário que será criado com o cloud-init
  sshkeys           = "ssh-rsa root@localhost"          # chave pública para o ssh
  environment       = ""                                # Será criada uma TAG no proxmox. O módulo habilita o statup da VM se for criada com a TAG "prod"
```

### Conhecendo o arquivo conf/.env
* Temos um arquivo de template que deverá ser salvo com o nome .env com as informações que mostraremos agora
```text
export PM_API_TOKEN_ID=         # API Token gerado no proxmox
export PM_API_TOKEN_SECRET=     # API Secret gerado no proxmox
```

***Mais informações, verificar na documentação oficial.* [Proxmox](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#pveum_tokens)

## Ansible e seu inventário
* Com o Ansible-core instalado, poderemos fazer a instalação e configuração de softwares nas novas maquinas virtuais.
Tão importante quanto isto, é a preparação de um inventário. Fazendo a separação correta, agrupando hosts e utilizando as group_vars de uma forma eficiente.
* O nosso inventário foi pensado apenas para o uso do playbook.
  * Foram criados 3 grupos
    - rancher_master

      *deveremos colocar todos hosts que farão parte do Control-plane*
    - rancher_worker

      *deveremos colocar todos hosts que farão parte do Control-plane*

    - rancher

      *Este contem apenas os outros dois grupos como filhos e por isso não precisa ser modificado*

**Hierarquia de diretórios**
```text
ansible/inventory/
├── group_vars
│   └── rancher.yaml
└── hosts
```
### Conhecendo o rancher.yaml
Este arquivo é referente ao group_vars do grupo rancher.

```text
remote_user: ubuntu                                                             # Usuário remoto para conexão via SSH
rancher_server_ip: "{{ hostvars[groups['rancher_master'][0]].ansible_host }}"   # Guardando o valor do IP do servidor Rancher **Não modificar**
rancher_url: "rancher.homelab.local"                                            # Indicar a url do Rancher
admin_password: "Admin123"                                                      # Indicar a senha Inicial do admin do Rancher. **Modificar na primeira utilizacão!**
longhorn_install: true                                                          # Indicar se o Longhorn deve ser instalado
```

## Conhecendo o nosso Makefile
Para orquestar a nossa execução, foi escolhido uma ferramenta muito conhecida e não tão utilizada quanto deverei.

Os arquivos Makefile são invocados quando de dentro do mesmo diretório se executa o comando make.

```bash
ubuntu@srv-ansible:~/projetoRancher$ make
 
Makefile commands:

  make infra_create     Create the infrastructure with Terraform and configure Rancher with Ansible
  make infra_destroy    Destroy the infrastructure with Terraform
  make k8s_install      Installing Kubernetes/Rahcner with Ansible
  make help             Show this help message

```

Vale a pena estudar um pouco sobre...

## Execução
Para iniciarmos o nosso projeto, faremos um clone deste repositório.

```bash
git clone  https://github.com/alexeiev/projetoRancher.git
cd projetoRancher
```
* 1 - Editar o arquivo do terraform par aindicar como irá criar suas VMs
* 2 - Editar o arquivo de configuração ./conf/.env (salvar o template como .env)
* 3 - Configurar o inventário do ansible (./ansible/inventory/hosts) com o nome das suas VMs e seus IPs
* 4 - Criar toda a infraestrutura com o seguinte comando:

```bash
make infra_create
```




## Autores

- [@alexeiev](https://www.github.com/alexeiev)
