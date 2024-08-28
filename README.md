# Instalação e Configuração Jenkins lts com Infra as Code

## Projeto de CI/CD.


Tabela de conteúdos
===================
<!--ts-->   
   * [Tecnologias](#🛠-tecnologias-utilizadas)
   * [Virtualização](#virtualização)
   * [Vagrant](#vagrant)
   * [Referências](#referências)
   * [Contribuição](#contribuição)
   * [Autor](#autor)
   * [Licença](#licença)
<!--te-->

### 🛠 Tecnologias Utilizadas

As seguintes ferramentas foram usadas na construção do projeto:

- [libvirtd (libvirt) 9.7.0](https://libvirt.org/)
- [Vagrant 2.3.4](https://www.vagrantup.com/)
- [Docker 24.0.7](https://docs.docker.com/engine/)
- [Ansible 2.9.27](https://docs.ansible.com/)
- [jenkins LTS 2.426.2](https://www.jenkins.io/doc/book/getting-started/)

### Virtualização

A Plataforma de virtualização utilizada para fins de Desenvoldimento e aprimoramento dos scripts para entrega de uma Maquina Virtual com o Jenkins Lts instalado sem a interação com sistema operacional.

Como base no conceito antes falado, foi utilizado o libvirt.

### Vagrant

Para interagir com o libvirt foi utilizado o Vagrant, que é utilizado para fazer todo o trabalho de criação da maquina virtual, instalação e configuração.

Será necessário criar um arquivo **.env** no diretório **files/jenkins** que contem o usuario e senha para o acesso administrador Jenkins e será utlizado pelo docker compose.

~~~yml

JENKINS_USER='admin'
JENKINS_PASS='password'

~~~

Após se certificar de ter instalado o **libvirt e vagrant** será necessário criar uma interface privada no libvirt, pré requisito da Virtual Machine, o arquivo para a criação desta interface está em **libvirt/network** e para cria-lo acesso como root e execute o comando.


~~~bash

sudo virsh net-create libvirt/network/private_network.xml

~~~

Logo após criar a Network **private_network** será necessário inicia-la e coloca-la na inicialização do libvirt, para quando o for criar a Virtual Machine o Vagrant normalmente inicialize. Execute os comandos.

~~~bash
sudo virsh net-start private_network
sudo virsh net-autostart private_network
~~~

Para iniciar o processo com **Vagrant** apenas execute o seguinte comando.

~~~bash

sudo vagrant up jenkins

~~~

Para as configurações de recursos para criação da vm o arquivo **environment.yaml** é o responsavel, e é preciso ter os seguintes itens de configuração.

~~~yml
---
- name: jenkins # Nome para VM
  box: debian/bookworm64 # A Box(Sistema Operacional) Utilizado
  hostname: jenkins # Hostname do servidor
  ipaddress: 192.168.56.104 # Endereço IP para o servidor
  memory: 3076 # Quantidade de Memoria Ram
  cpus: 2 # Quantidade de Cpus
  provision: provision/ansible/jenkins.yaml  # Plaibook ansible
~~~


No Diretório **provision** contem os arquivos de automação, instalação e configuração da VM para que o Jenkins seja instalado de forma que o usuário apenas começe a utilizar os seus recursos.

Por isso que dentro desse diretório contem uma **playbook** no diretorio **ansible/jenkins.yaml**, que contem todas as configurações necessárias para instalação, configuração, atualização, copia de arquivos e customizações no sistema operacional centos 8 e instalação do Jenkins.

O Jenkins tem um recurso bastante interessante que é, a posibilidade de instalar os plugins quando se faz um docker build, para isso é necessário o arquivo **plugins.txt** que está localizado **file/jenkins** onde contem plugins que são basicos para uma instalação inicial, o plugin mais importante é **Configuration as Code (JCasC)**.

Para instalação do Jenkins ficar o mais automatico possivel foi utilizado o plugin **Configuration as Code (JCasC)** que automatiza a configurações iniciais do jenkins, para essa magica acontecer é necessário do arquivo **jenkins.yaml** que está no diretório **file/jenkins** que contem algumas configurações basicas.

Para tudo isso acontecer bem transparente, foi utilizado o docker, onde o **Dockerfile** interage com o **docker-compose.yml** gerando um build de um container apartir das configurações feitas neste arquivo, destacando a copia dos arquivos **jenkins.yaml, plugins.txt**, que ao ser copiado para determinados diretórios no container do jenkins eles são executados e fazem mais uma magica acontecer.

### Referências

- [Instalação libvirt Fedora Linux](https://developer.fedoraproject.org/tools/virtualization/installing-libvirt-and-virt-install-on-fedora-linux.html)
- [Instalação Vagrant](https://developer.hashicorp.com/vagrant/install)
- [Instalação ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Jenkins JCasc](https://www.jenkins.io/projects/jcasc/)

### Contribuição

- Wagner Oliveira

### Autor

- Wagner Oliveira

### Licença

- [GNU General Public License (GPL)](https://www.gnu.org/licenses/gpl-3.0.html)