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
 apt-get install -y kubelet kubeadm kubectl 

 apt-mark hold kubelet kubeadm kubectl

#Instalação dos útilitários do master

#Argo CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

#Helm CLI
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm -y
#git
apt install git -y

cd /home/admin

# download dos manifestos dos utilitários de rede e monitoramento
# nginx ingress, metrics-server, calico cni
wget -O nginx-baremetal.yaml https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/baremetal/deploy.yaml
wget -O metrics-server.yaml https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
wget -O calico-cni.yaml https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml