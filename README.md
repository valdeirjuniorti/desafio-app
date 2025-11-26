📘 Desafio Técnico — SRE/DEVOPS

Avaliação técnica para a vaga de Site Reliability Engineer (SRE).

🎯 Objetivo da Avaliação

Este desafio tem como finalidade avaliar:

Habilidades Técnicas

Infraestrutura como Código (IaC): Provisionamento e gerenciamento automatizado de recursos.

Contêineres e Orquestração: Docker e Kubernetes (criação, deploy, distribuição e manutenção).

Arquitetura Cloud e Redes: GCP (adaptar termos originalmente descritos em AWS), VPC, subnets, segurança.

DevOps & Boas Práticas: Código limpo, seguro, resiliente, com alta disponibilidade.

Observabilidade: Monitoramento, métricas, logs, rastreamento e saúde da aplicação.

📝 Descrição Geral do Desafio

A empresa Domo (Banco Mercantil) está migrando sua infraestrutura on-premise para GCP.
O desafio consiste em modernizar uma aplicação monolítica, quebrando-a em microsserviços (Front-end, Back-end e Banco de Dados), e provisionar toda a infraestrutura na nuvem usando boas práticas de Engenharia de Confiabilidade.

O sucesso da entrega depende de:

Qualidade técnica do código,

Arquitetura,

Segurança,

Alta disponibilidade,

Observabilidade,

Clareza da documentação.

📦 Componentes Principais

O desafio está dividido em 3 partes:

Infraestrutura (IaC)

Back-end

Front-end

📤 Entrega

O candidato deve:

Criar um repositório dedicado no GitHub ou GitLab.

Organizar as pastas por módulos (infra, backend, frontend).

Enviar para o time de recrutamento:

Link do repositório

Perfil atualizado do LinkedIn

Currículo

Incluir um README.md detalhado com:

Arquitetura

Como executar a solução

Comandos de deploy

Fluxo geral de funcionamento

📚 Escopo do Projeto

O objetivo é segmentar o monolito e criar a infraestrutura em GCP para os componentes:

Front-end

Back-end

Banco de Dados

☁️ Requisitos de Infraestrutura e Tecnologia
Provedor de Nuvem

Google Cloud Platform (GCP)
(Os termos originais de AWS devem ser adaptados para GCP.)

Infraestrutura como Código

Terraform e/ou Ansible.

Ambiente

Kubernetes (GKE)

Docker containers

Servidores Linux (quando necessário)

Rede

Criar:

1 VPC

3 subnets privadas

3 subnets públicas

Alta Disponibilidade & Observabilidade

Aplicações resilientes

Monitoramento básico (métricas / logs / health checks)

🛠️ Tarefas de Implementação
🔧 1. Infraestrutura (IaC)

O candidato deve provisionar:

VPC e subnets (privadas e públicas)

Firewalls / Security Groups (GCP: Firewall Rules)

Roles e policies (IAM)

Banco de dados relacional (Cloud SQL – PostgreSQL ou MySQL)

Cluster Kubernetes (GKE)

DNS / Load Balancer (se necessário)

🧩 2. Back-end & Front-end (Containers e Orquestração)

A partir das pastas backend e frontend, executar:

Contêineres

Utilizar o Dockerfiles do repositorio

Publicar imagens (pode ser Container Registry ou Artifact Registry do GCP)

Kubernetes

Criar manifestos para:

Deployments

Services

Ingress

ConfigMaps / Secrets

Horizontal Pod Autoscaler (opcional)

Deploy Automatizado

Criar um script único que aplique todos os manifests no cluster.

🔗 3. Conexões e Configurações
Back-end

Configurar acesso ao banco via application.yml

Criar um usuário dedicado no banco

Variáveis de ambiente via ConfigMap/Secret

Front-end

Ajustar environment.ts apontando o endpoint da API

Exposição

Aplicações devem ser acessíveis via URL usando DNS + Ingress

Segurança

Liberar apenas as portas estritamente necessárias

⭐ Diferenciais (Extras)

Uso de Helm Charts

Separação por namespaces

Health checks configurados

Pipeline CI/CD automatizado

Observabilidade mínima (Prometheus, Grafana, Stackdriver etc.)

🧠 Alternativa Teórica (Opcional)

Caso não seja possível realizar o desafio completo, o candidato pode:

1️⃣ Escolher um segmento bancário

Ex.: pagamentos, crédito, cobrança, seguros.

2️⃣ Descrever o contexto

Conceito

Regras de negócio

Problema a ser resolvido

3️⃣ Criar um desenho da solução

Ferramentas recomendadas:

Diagrams.net

Excalidraw

4️⃣ Justificar o uso dos serviços da GCP

Infraestrutura, banco, computação, segurança, etc.

5️⃣ Demonstrar observabilidade

Métricas

Logs

Traces

Alertas

Incidentes

⚠️ Considerações Finais

Todos os recursos devem ser criados usando créditos gratuitos da GCP.

É obrigatório destruir os recursos ao final para evitar cobranças.
