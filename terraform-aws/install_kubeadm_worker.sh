#!/bin/bash

#####################################################################################
# 
# Versão 1.0 - 12/09/2024
#
# Descrição: 
#   - Intala o ambiente para rodar KubeADM em derivados Debian
#     usa o gerenciador de pacotes apt-get
#   - Executa em modo root ( Inicialmente pensado para executar no user_data AWS)
#   - Para executar local, desativar o swap 
#
#####################################################################################

apt-get update

apt-get install gpg -y

cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

 modprobe overlay
 modprobe br_netfilter


# Configuração dos parâmetros do sysctl.
cat <<EOF |  tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Aplica as definições do sysctl sem reiniciar a máquina
 sysctl --system
-- 

#Instalacao docker

# Add Docker's official GPG key:
 apt-get update
 apt-get install -y ca-certificates curl 
 install -m 0755 -d /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
 chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null
 apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

----
# Instalação ContainerD

 apt update &&  apt install containerd.io -y

 mkdir -p /etc/containerd && containerd config default |  tee /etc/containerd/config.toml 

 sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

  systemctl restart containerd

#Kubeadm Kubctl Kubelet

 apt-get update && \
 apt-get install -y apt-transport-https ca-certificates curl

#pode ser necessário instalar o gpg
 curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key |  gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

 echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' |  tee /etc/apt/sources.list.d/kubernetes.list

 apt-get update && \
 apt-get install -y kubelet kubeadm 

 apt-mark hold kubelet kubeadm 

