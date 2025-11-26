# Desafio Técnico — Site Reliability Engineer (SRE) / DEVOPS 

## 1. Visão Geral
Este documento descreve o escopo, requisitos e diretrizes do Desafio Técnico para a posição de Site Reliability Engineer (SRE) /DEVOPS .  
O objetivo principal é avaliar competências técnicas relacionadas a infraestrutura, automação, arquitetura cloud e observabilidade, dentro de um padrão corporativo e formal.

CRIAR UM NOVO REPOSSITORIO COM RESULTADO PARA AVALIACAO EX: DESAFIO-APP-RESULTADO

---

## 2. Objetivo da Avaliação
A avaliação contempla análise das seguintes capacidades:

### 2.1 Infraestrutura como Código (IaC)
- Provisionamento automatizado de recursos.
- Padronização de ambientes e reutilização de módulos.

### 2.2 Contêineres e Orquestração
- Construção e execução de contêineres Docker.
- Deploy, gerenciamento e escalabilidade via Kubernetes.

### 2.3 Arquitetura Cloud e Redes
- Modelagem de redes na GCP.
- Implementação de VPCs, sub-redes, regras de firewall e controles de segurança.

### 2.4 Práticas de DevOps
- Automação de processos.
- Código limpo e seguro.
- Adoção de boas práticas de CI/CD.

### 2.5 Observabilidade
- Monitoramento.
- Coleta de métricas.
- Centralização de logs.

---

## 3. Contexto do Desafio
A empresa está conduzindo a migração de sua infraestrutura on-premises para a Google Cloud Platform (GCP).  
O candidato deverá modernizar uma aplicação monolítica fornecida, segmentando-a e implementando uma arquitetura que suporte microsserviços, escalabilidade e boas práticas de disponibilidade.

---

## 4. Escopo do Desafio
O desafio compreende três componentes principais:

- **Infraestrutura**
- **Back-end**
- **Front-end**

O resultado será avaliado com base em organização, segurança, padronização, arquitetura e documentação.

---

## 5. Entregáveis
O candidato deverá:

1. Criar um repositório dedicado no GitHub ou GitLab.  
2. Estruturar os diretórios de maneira organizada (infra/, backend/, frontend/).  
3. Submeter:
   - Link do repositório
   - Perfil do LinkedIn
   - Currículo atualizado  
4. Incluir documentação completa para execução do projeto.

---

## 6. Requisitos Técnicos

### 6.1 Infraestrutura
- Provisionar VPC e sub-redes públicas e privadas.  
- Configurar IAM, Firewall Rules e políticas aplicáveis.  
- Criar banco de dados relacional em Cloud SQL.  
- Provisionar um cluster Kubernetes (GKE).  

### 6.2 Back-end e Front-end
- Criar imagens Docker baseadas no código fornecido.  
- Definir manifestos Kubernetes (Deployments, Services, ConfigMaps, Secrets, Ingress).  
- Garantir comunicação entre serviços.  
- Configurar variáveis de ambiente e apontamentos necessários.

### 6.3 Automação
- Criar script único de deploy para o cluster.  

### 6.4 Segurança
- Respeitar o princípio de menor privilégio.  
- Liberar somente portas essenciais.  

---

## 7. Diferenciais Técnicos
A implementação pode ser enriquecida com:

- Uso de Helm Chart.  
- Estruturação por namespaces.  
- Implementação de health checks.  
- Pipelines CI/CD funcionais.  
- Observabilidade via Stackdriver, Prometheus ou ferramentas similares.

---

## 8. Alternativa Teórica (Opcional)
Caso não haja disponibilidade para implementação prática:

1. Escolher um segmento bancário (pagamentos, crédito, seguros etc.).  
2. Definir contexto, regras de negócio e problema.  
3. Criar desenho arquitetural da solução.  
4. Justificar escolha dos serviços GCP utilizados.  
5. Descrever observabilidade mínima necessária.

---

## 9. Considerações Finais
- Os recursos devem ser provisionados com créditos gratuitos da GCP.  
- Todos os recursos devem ser removidos ao final dos testes para evitar cobranças indevidas.  
- O candidato deve prezar pela qualidade, clareza e padronização da entrega.

---

## 10. Contato da Equipe
Em caso de dúvidas, entre em contato com a equipe responsável pelo processo seletivo.
