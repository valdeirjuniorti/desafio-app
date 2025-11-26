Desafio Técnico SRE
Esta etapa visa avaliar as competências técnicas dos(as) candidatos(as) para a vaga de Site Reliability Engineer (SRE).

Objetivos da Avaliação
O teste tem como foco a avaliação das seguintes habilidades e conhecimentos:

Infraestrutura como Código (IaC): Capacidade de provisionar e gerenciar recursos de infraestrutura de forma automatizada.

Contêineres e Orquestração (Kubernetes/Docker): Proficiência na criação, distribuição e gerenciamento de aplicações conteinerizadas.

Arquitetura Cloud e Redes: Conhecimento em provedores de nuvem (AWS/Azure/GCP) e configuração de ambientes de rede (VPC, subnets, segurança).

Práticas de DevOps e Boas Práticas de Código: Demonstração de soluções bem estruturadas, seguras, com alta disponibilidade e documentação clara.

Observabilidade: Implementação de mecanismos de monitoramento e rastreabilidade para garantir a saúde e o desempenho da aplicação.

Descrição do Desafio
A Domo (Banco Mercantil) está em processo de migração de sua infraestrutura local (On-Premises) para a Cloud Pública. O desafio consiste em modernizar uma aplicação monolítica existente, segmentando-a em microsserviços e provisionando a infraestrutura necessária para suportar a nova arquitetura. A implementação deve contemplar os benefícios da computação distribuída, como escalabilidade, elasticidade, redução de custos e segurança.

O desafio está dividido em três componentes principais:

Infraestrutura

Back-end

Front-end

O sucesso da entrega será avaliado pela aplicação de boas práticas e pela qualidade da documentação e do código.

Entrega
A solução deve ser submetida através dos seguintes passos:

Criação de um repositório dedicado no GitHub ou GitLab.

Estruturação clara das pastas no repositório para facilitar a identificação dos componentes.

Envio do link do repositório, juntamente com o perfil atualizado do LinkedIn e currículo, à equipe de recrutamento.

É altamente recomendável incluir um arquivo README.md detalhado com uma descrição da aplicação e instruções claras para sua execução.

Escopo
O objetivo principal é segmentar a aplicação monolítica em Front-end, Back-end e Banco de Dados e criar a infraestrutura para hospedagem em um provedor de nuvem GCP.

Requisitos de Infraestrutura e Tecnologia
Provedor de Nuvem: GCP. (A terminologia usada no escopo a seguir refere-se à AWS, favor ser adaptada ao provedor GCP).

Infraestrutura como Código (IaC): Utilização de Terraform e/ou ansible para provisionar os recursos.

Ambiente de Execução: Os serviços devem rodar em servidores Linux e containers Kubernetes.

Rede: Configuração de uma VPC com três subnets privadas (sem acesso direto da rede externa) e três subnets públicas (expostas com as devidas configurações de segurança).

Alta Disponibilidade e Observabilidade: Promover alta disponibilidade e providenciar uma observabilidade mínima para as aplicações.

Tarefas de Implementação
O candidato deve segmentar o monolito recebido, que possui as camadas de Front-end, Back-end e Banco de Dados.

Infraestrutura (IaC)
Provisionar VPC e Subnets.

Configurar Roles/Policies e Security Groups (SG).

Criar um banco de dados relacional.

Provisionar o cluster Kubernetes.

Back-end e Front-end (Contêineres e Orquestração)
A partir dos códigos-fonte fornecidos nas pastas backend e frontend :

Construir as imagens Docker das aplicações.

Criar os manifestos de recursos Kubernetes (Deployments, Services, Ingresses, ConfigMaps, etc.) para ambas as aplicações.

Desenvolver um script que realize o deploy da aplicação em um único comando no cluster Kubernetes.

Conexão e Configuração:

O Back-end deve ser configurado para se conectar ao banco de dados provisionado (ajustando o application.yml).

Deve-se criar um usuário no banco de dados para acesso.

O Front-end deve ter seu apontamento para a API do Back-end configurado (environment.ts).

As aplicações devem ser acessíveis via uma URL específica (DNS/Ingress).

Garantir que apenas as portas estritamente necessárias sejam liberadas nos Security Groups.

(Detalhes técnicos adicionais sobre a configuração do banco de dados, variáveis de ambiente e o fluxo de login e home screen da aplicação original foram mantidos, pois são essenciais para a execução do desafio.)

Diferenciais (Extras)
Utilização da ferramenta HELM.

Divisão dos recursos por namespaces no Kubernetes.

Implementação de Health Checks na aplicação.

Realização do deploy via Pipeline CI/CD.

Configuração de observabilidade mínima da infraestrutura com ferramenta de sua escolha.

Alternativa Teórica
Caso não haja disponibilidade para a codificação completa do desafio, o candidato pode optar pela Alternativa Teórica.

Estudo de Caso e Desenho de Solução
O candidato deve:

Escolher um segmento bancário para modernização (e.g., pagamentos, cobrança, crédito, seguros).

Contextualizar o segmento (conceito, regra de negócio e um desafio a ser resolvido).

Construir um "Desenho de Solução" para a modernização, utilizando ferramentas como Diagrams.net ou Excalidraw.

Justificar o uso dos serviços de nuvem ( GCP).

Aplicar Monitoramento e Observabilidade Mínima (métricas, logs, traces, alertas, incidentes), detalhando as ferramentas utilizadas.


Considerações Finais
Todos os recursos devem ser criados utilizando os créditos gratuitos do provedor de nuvem.

É mandatório destruir todos os recursos após a conclusão e testes do desafio, a fim de evitar cobranças indevidas ou esgotamento dos créditos.