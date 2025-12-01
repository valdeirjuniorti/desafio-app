# Script de Deploy - Desafio App

Este documento descreve como usar o script único de deploy (`deploy.py`) para fazer o deploy completo da aplicação no cluster Kubernetes.

## Pré-requisitos

1. **Python 3.6+** instalado
2. **kubectl** instalado e configurado
3. **Acesso ao cluster GKE** configurado
4. **Secrets criados** (veja seção abaixo)

## Instalação

O script não requer dependências externas, apenas bibliotecas padrão do Python.

## Uso Básico

### Deploy Completo

Para fazer o deploy completo da aplicação (backend, frontend e observabilidade):

```bash
python deploy.py
```

### Deploy de um Namespace Específico

Para fazer deploy apenas de um componente:

```bash
# Apenas backend
python deploy.py --namespace backend

# Apenas frontend
python deploy.py --namespace frontend

# Apenas observabilidade
python deploy.py --namespace observability
```

### Modo Dry-Run

Para verificar o que seria aplicado sem fazer mudanças reais:

```bash
python deploy.py --dry-run
```

### Deploy sem Observabilidade

Para fazer deploy sem os recursos de observabilidade (Prometheus, Loki, Promtail):

```bash
python deploy.py --skip-observability
```

## Secrets Necessários

Antes de executar o deploy, você precisa criar os seguintes secrets no cluster:

### 1. Secret do Backend (DATABASE_URL)

```bash
kubectl create secret generic backend-secrets \
  --from-literal=DATABASE_URL='postgres://user:password@host:5432/database' \
  -n backend
```

### 2. Secret do Registry (Backend)

```bash
kubectl create secret docker-registry registry-secret \
  --docker-server=us-central1-docker.pkg.dev \
  --docker-username=_json_key \
  --docker-password="$(cat path/to/key.json)" \
  -n backend
```

### 3. Secret do Registry (Frontend)

```bash
kubectl create secret docker-registry registry-secret \
  --docker-server=us-central1-docker.pkg.dev \
  --docker-username=_json_key \
  --docker-password="$(cat path/to/key.json)" \
  -n frontend
```

**Nota:** O script verifica automaticamente se os secrets existem e avisa caso estejam faltando.

## Ordem de Aplicação

O script aplica os recursos na seguinte ordem (importante para dependências):

1. **Namespaces** - Cria os namespaces necessários
2. **ServiceAccounts** - Cria as contas de serviço
3. **ConfigMaps** - Aplica configurações
4. **Deployments** - Cria os deployments
5. **Services** - Expõe os serviços
6. **HPA** - Configura auto-scaling
7. **Ingress** - Configura roteamento externo

## Verificação Pós-Deploy

Após o deploy, o script automaticamente:

1. Aguarda os pods ficarem prontos (timeout de 5 minutos)
2. Mostra o status de todos os recursos

### Verificação Manual

Você também pode verificar manualmente:

```bash
# Status de todos os recursos
kubectl get all --all-namespaces

# Logs do backend
kubectl logs -f deployment/backend -n backend

# Logs do frontend
kubectl logs -f deployment/frontend -n frontend

# Status dos pods
kubectl get pods --all-namespaces

# Descrição de um pod específico
kubectl describe pod <pod-name> -n <namespace>
```

## Troubleshooting

### Erro: "kubectl não está instalado"

Instale o kubectl seguindo a [documentação oficial](https://kubernetes.io/docs/tasks/tools/).

### Erro: "Não é possível conectar ao cluster"

1. Verifique se você está autenticado no GCP:
   ```bash
   gcloud auth login
   ```

2. Configure o kubectl para o cluster:
   ```bash
   gcloud container clusters get-credentials <cluster-name> --zone <zone> --project <project-id>
   ```

3. Verifique o contexto atual:
   ```bash
   kubectl config current-context
   ```

### Erro: "Secret não encontrado"

Crie os secrets necessários conforme descrito na seção "Secrets Necessários" acima.

### Pods não ficam prontos

1. Verifique os logs do pod:
   ```bash
   kubectl logs <pod-name> -n <namespace>
   ```

2. Verifique os eventos:
   ```bash
   kubectl describe pod <pod-name> -n <namespace>
   ```

3. Verifique se as imagens estão disponíveis no registry

4. Verifique se os secrets estão corretos

## Opções do Script

```
usage: deploy.py [-h] [--dry-run] [--skip-observability] [--namespace {backend,frontend,observability}]

Script único de deploy para o cluster Kubernetes

optional arguments:
  -h, --help            show this help message and exit
  --dry-run             Executa em modo dry-run (não aplica mudanças)
  --skip-observability  Pula o deploy dos recursos de observabilidade
  --namespace {backend,frontend,observability}
                        Aplica apenas recursos de um namespace específico
```

## Exemplos Completos

### Deploy completo em produção

```bash
# 1. Verificar conexão
kubectl cluster-info

# 2. Verificar secrets
kubectl get secrets -n backend
kubectl get secrets -n frontend

# 3. Deploy
python deploy.py

# 4. Verificar status
kubectl get all --all-namespaces
```

### Deploy apenas do backend (desenvolvimento)

```bash
python deploy.py --namespace backend
```

### Teste de configuração (dry-run)

```bash
python deploy.py --dry-run
```

## Integração com CI/CD

O script pode ser facilmente integrado em pipelines CI/CD. Exemplo para GitHub Actions:

```yaml
- name: Deploy to GKE
  run: |
    python deploy.py
```

Ou com variáveis de ambiente:

```yaml
- name: Deploy to GKE
  env:
    KUBECONFIG: ${{ secrets.KUBECONFIG }}
  run: |
    python deploy.py
```

## Estrutura de Arquivos

O script espera a seguinte estrutura de diretórios:

```
manifests/
├── backend/
│   ├── namespace.yaml
│   ├── serviceaccount.yaml
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── hpa.yaml
│   └── ingress.yaml
├── frontend/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── hpa.yaml
│   └── ingress.yaml
└── observability/
    ├── namespace.yaml
    ├── prometheus-*.yaml
    ├── loki-*.yaml
    └── promtail-*.yaml
```

## Segurança

- O script não armazena credenciais
- Secrets devem ser criados manualmente ou via ferramentas seguras (ex: Sealed Secrets, External Secrets Operator)
- Use `--dry-run` antes de fazer deploy em produção
- Revise os manifests antes de aplicar

## Suporte

Em caso de problemas:

1. Execute o script com `--dry-run` para verificar o que será aplicado
2. Verifique os logs do script
3. Verifique os logs dos pods no cluster
4. Consulte a documentação do Kubernetes

