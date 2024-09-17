## Objetivo:
**A idéia principal** é que o granafa ao detectar uma anomália, envie um alerta para o **Telegram** e após isso execute uma ação no cluster enviando um webhook para o pod de api, nesse caso **deletar o pod**.
- No payload padrão (segundo documentação não é boa prática alterar), o grafana envia dados sobre o que gerou alerta, como é possível ver na imagem, é possível extrair esses dados e executar uma ação a partir da api.
![Painel de status de alerta do grafana](/assets_docs/grafana_painel_alerta.png)

### Configuração no grafana:
**Webhook**
- Configure 1 contact point do tipo **webhook**
- na url coloque o DNS do seu serviço no formato **nomeService.namespace.svc.cluster.local:porta/endpoint**
![Configuração do Grafana Webhook](/assets_docs/grafana_config_webhook.png)

    **Cerfitique-se que a API é capaz de tratar o payload, nesse caso foi necessário converter e tratar como string, pois houve erros no JSON**

**Telegram**
- Necessário criar um BOT no telegram, basta enviar uma mensabem pro BotFather
- Após criado o BotFather fornecerá o token do seu BOT, será necessário para configurar no Grafana
- Inície um grupo com seu bot e mande uma mensagem no grupo marcando ele.
- Aguarde alguns mínutos e acesse https://api.telegram.org/bot[tokendoseubot]>/
getUpdates
- Você vai precisar do valor do campo id 
- **no Grafana** basta preencher os campos com essas informações, conforme imagem: 
![Configuração do Grafana Telegram](/assets_docs/grafana_config_telegram.png)
- Aqui você pode enviar uma mensagem de teste para verificar o funcionamento
### API
- Inicialmente apenas executa a deleção do recurso



