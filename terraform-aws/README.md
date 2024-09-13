## VPC pública com 1 ec2

- VPC
- 2 Subnets públicas
- 2 Subnets privadas
- Ec2 
    - Necessário alterar o número de instâncias no variables.tf  para master/workers valor inicial 1 master 3 worker
    - altere para o tipo de ec2 adequado ao caso de uso 

- 1 security group 
  - Atualmente com full-ingress para testes.
- 1 Internet gateway
- Tabela de rotas e todas as associações necessárias
### User_data
- Script de instalação do Kubeadm separado em masters/workers
- Pensado para distro Debian

### Criar o arquivo terraform.tfvars
```
profifle = "profile cli aws"
key-name = "nome da chave-ssh"