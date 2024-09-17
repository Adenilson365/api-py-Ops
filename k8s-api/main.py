from fastapi import FastAPI, HTTPException, Request
from kubernetes import client, config
from typing import Optional
from datetime import datetime
import re

app = FastAPI()

try:
    config.load_incluster_config()  # Tenta carregar a configuração dentro do cluster
except Exception as e:
    raise RuntimeError(f"Erro ao carregar configuracao kubeconfig: {e}")

v1 = client.CoreV1Api()

@app.get("/pods")
def list_pods(namespace: Optional[str] = "api-ns"):
    ret = v1.list_namespaced_pod(namespace=namespace)
    pod_list = [
        {
            'pod_ip': i.status.pod_ip,
            'namespace': i.metadata.namespace,
            'name': i.metadata.name,
            'status': i.status.phase,
            'start_time': i.status.start_time.isoformat() if i.status.start_time else None,
            'time_elapsed_minutes': (datetime.utcnow() - i.status.start_time.replace(tzinfo=None)).total_seconds() / 60 if i.status.start_time else None
            #realizar a correção do utcnow - datetime não funcionou a principio.
        } for i in ret.items
    ]
    return pod_list

@app.post("/delete_pod")
def delete_pod(pod_name: str, namespace: Optional[str] = "api-ns"):
    try:
        v1.delete_namespaced_pod(name=pod_name, namespace=namespace)
        return {"status": f"Pod {pod_name} deletado!"}
    except client.exceptions.ApiException as e:
        raise HTTPException(status_code=500, detail=f"Falha ao executar delete: {e}")
    

@app.post("/delete")
async def delete_pod(request: Request):
    data = await request.body()  # Captura o corpo da requisição como string
    data_str = data.decode("utf-8")  # Decodifica para string UTF-8
    #debug devido ao erro no json do payload grafana, remover na versão final 
    print("Datas") 
    print(data)
    print("Datas")
    print(data_str)

    try:
        #debug devido ao erro no json do payload grafana, remover na versão final 
        print("Entrou Aqui")

        # Usando regex para extrair os valores de pod_name e namespace
        pod_name_match = re.search(r'"pod"\s*:\s*"([^"]+)"', data_str)
        namespace_match = re.search(r'"namespace"\s*:\s*"([^"]+)"', data_str)
        #debug devido ao erro no json do payload grafana, remover na versão final 
        print(f"Valores Match: {pod_name_match}, {namespace_match}")

        if not pod_name_match or not namespace_match:
            raise HTTPException(status_code=400, detail="Pod name or namespace not found in the request")

        pod_name = pod_name_match.group(1)
        namespace = namespace_match.group(1)
    
        #debug devido ao erro no json do payload grafana, remover na versão final 
        print(f"Valores: {pod_name}, {namespace}")

        # Deletar o pod
        v1.delete_namespaced_pod(name=pod_name, namespace=namespace)
        
        return {"status": f"Pod {pod_name} deletado!"}
    
    except KeyError as e:
        raise HTTPException(status_code=400, detail=f"Erro: {e}")
    except client.exceptions.ApiException as e:
        raise HTTPException(status_code=500, detail=f"Erro: {e}")
