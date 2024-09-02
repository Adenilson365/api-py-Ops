## Repositório de GitOps 
- [Repositório de código](https://github.com/Adenilson365/praticando-api-py) 

### Helm charts utilizados:
- [Prometheus](https://artifacthub.io/packages/helm/prometheus-community/prometheus)
- [Grafana](https://artifacthub.io/packages/helm/grafana/grafana)
- [Jaeger](https://artifacthub.io/packages/helm/jaegertracing/jaeger)
### Links de Documentação:
- [ArgoCD](https://artifacthub.io/packages/helm/jaegertracing/jaeger
)

---
### Proceso de instalçao:
- Criar Namespaces próprios:
  - Grafana e Prometheus
    ```
    kubectl create namespace observabilidade
    ```
  - Jaeger
    ```
    kubectl create namespace jaeger
    ```
  - Verificar criação:
    ```
    kubectl get ns 
    ```
  - Saída esperada:
  
    |NAME             | STATUS  | AGE    |
    |-----------------|---------|--------|
    |kube-system      |Active   |3h9m    |
    |default          |Active   |2d22h   |
    |jaeger           |Active   |176m    |
    |observabilidade  |Active   |179m    |

- Instalar ArgoCD
  - [Seguir Documentação de referência](https://argo-cd.readthedocs.io/en/stable/getting_started/)
  - Observações importantes:
    - ArgoCD tem seu namespace próprio **argocd**
    - Substituir o guestbook pelo nome da sua aplicação como abaixo (após: create e --path) :
    ```
    argocd app create api --repo https://github.com/Adenilson365/api-py-Ops.git --path api --dest-server https://kubernetes.default.svc --dest-namespace default
    ```
    - É possível realizar toda a instalação seguindo a documentação passo a passo
    - A URL de sincronia precisa ser a mesma usada para clonar o repositório https (.git) 
    - Para realizar a gestão via interface WEB realizar o port-froward conforma documentação ou comando abaixo (Executará na 8080 do navegador):
    ``` 
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ``` 
    - Usuário padrão admin
    - Comando para obter a senha na documentação.
- Sincronizar ArgoCD

- Na interface gráfica mostra o status da sua aplicação:
    ![alt text](/doc-assets/image.png)
    - Sync: realiza a sincronia
    - Details: é possível realizar mais configurações de sync

    - Ative para cincronização a cada 3 minutos: 
    ![alt text](/doc-assets/sync.png)
    - Ative o prune (para que o ArgoCD consiga deletar recursos.)
    ![alt text](/doc-assets/sync-prune.png)

- Caso não tenha executado o comando de sync na linha de comando, o primeiro acesso será necessário realizar o sync.
- Depois é possível acompanhar pela interface gráfica o andamento da sua aplicação.

### ArgoCD webhook: 
  - Vá no seu repositório de gitOps, em settings, em webhook, add webhook

### Prometheus: 
- A aplicação já conta com as annotations necessárias, basta instalar o do artifacthub.io no namespace observabilidade:
```
helm install my-prometheus prometheus-community/prometheus --version 25.27.0 --namespace observabilidade
```
- Para acesso será necessário realizar o port-forward:
```
kubectl port-forward service/my-prometheus-server 31102:80 -n observabilidade
```
- Se OK , ao acessar a interface web, no menu status > target seus endpoitns /metrics devem estar listados como abaixo:
![alt text](/doc-assets/targets-promethesus.png)

### Grafana
- Instalar no namespace observabilidade
```
helm install my-grafana grafana/grafana --version 8.5.0 --namespace observabilidade
```
- Para acesso será necessário realizar o port-forward:
```
kubectl port-forward service/my-grafana 31103:80 -n observabilidade
```
- Para login:
    - Usuário padrão: admin
    - Senha Inicial, necessário obter com o comando abaixo:
    ```
    kubectl get secret --namespace observabilidade my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```
    - Depois alterar na interface gráfica no menu: Administration>Users and access
- Adicionar prometheus como base de dados:
  - Navegue no menu: connections > new data source 
  - Escolha entre as opções o prometheus, na nova aba clique em add new datasource.
  - Na janela que abrir adicione no campo url 
  ![alt text](/doc-assets/prometheus-url.png)
  ```
  http://my-prometheus-server:80
  ```
  - Caso tenha alterado o nome da release ao instalar, use o nome do seu serviço prometheus (finalizado em server).
  - se OK, ao clicar em save e test terá mensagem de sucesso e seu grafana está conectado ao prometheus. 
  - Basta criar seus Dashboards.
