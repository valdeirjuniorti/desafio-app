# Desafios App

Aplicação full-stack de **Desafios Pessoais** (hábitos, estudos, treinos etc.), construída como exemplo para estudo de:
- Frontend (React + Vite)
- Backend (Node.js + Express)
- Banco de dados (PostgreSQL)
- Conteinerização com K8S

---

## 1. Pré-requisitos

Antes de rodar o projeto, tenha instalado:

- **K8S** 
- **GKE** 
- Opcional: **Node.js 18+** e **npm**, caso queira rodar frontend/backend fora de containers para teste local

---

## 2. Estrutura do projeto

```txt
desafios-app/
  backend/
    Dockerfile
    package.json
    .env.example
    src/
      index.js
      db.js
      routes/
        challenges.js
  frontend/
    Dockerfile
    package.json
    vite.config.js
    index.html
    src/
      main.jsx
      App.jsx
```

### Backend (Node + Express + PostgreSQL)

- Porta padrão: **4000**
- Principais rotas:
  - `GET  /health` – checa se a API e o banco estão respondendo
  - `GET  /api/challenges` – lista desafios
  - `POST /api/challenges` – cria um novo desafio
  - `PUT  /api/challenges/:id` – atualiza um desafio
  - `DELETE /api/challenges/:id` – remove um desafio

### Frontend (React + Vite)

- Renderiza uma tela simples para:
  - Criar desafios
  - Editar desafios
  - Excluir desafios
  - Listar desafios cadastrados

---

## 3. Subindo tudo com K8S

> Esses passos assumem que você está na pasta **desafios-app** .

### 3.1. (Opcional) Instalar dependências localmente

Não é obrigatório para rodar com Docker, mas útil se for abrir no VS Code e rodar fora dos containers:

```bash
cd backend
npm install
cd ../frontend
npm install
cd ..
```


Isso irá:

- Criar e subir:
  - `db` (PostgreSQL na porta 5432)
  - `backend` (Node + Express na porta 4000)
  - `frontend` (Nginx servindo build do React na porta 3000)

### 3.3. Acessos

- Frontend:  
  http://localhost:3000

- Backend (API):  
  http://localhost:4000/api/challenges

- Healthcheck da API:  
  http://localhost:4000/health

> **Obs.:** O banco de dados fica acessível na porta `5432` (localhost) com:
> - DB: `desafios`
> - User: `desafios_user`
> - Senha: `desafios_pass`

---

## 4. Variáveis de ambiente

O backend usa a variável `DATABASE_URL`.  


```env
DATABASE_URL=postgres://desafios_user:desafios_pass@db:5432/desafios
```

Se quiser rodar o backend localmente (sem Docker), você pode:

1. Copiar o arquivo `.env.example`:

```bash
cd backend
cp .env.example .env
```

2. E ajustar o valor de `DATABASE_URL` se mudar algo na configuração do Postgres local.

---

## 5. Fluxo de uso da aplicação

1. Acesse o **frontend** em `http://localhost:3000` ou a DNS que for configurado
2. Preencha o formulário:
   - Título
   - Descrição
   - Dificuldade (`Fácil`, `Médio`, `Difícil`)
   - Status (`Pendente`, `Em andamento`, `Concluído`)
   - Categoria (ex.: estudos, saúde)
   - Datas de início/fim (opcional)
   - Progresso (slider 0–100%)
4. Clique em **Criar desafio**
5. O desafio aparecerá na lista logo abaixo
6. Você pode:
   - Clicar em **Editar** para alterar um desafio
   - Clicar em **Excluir** para remover um desafio

---

## 6. Testes recomendados para validar o projeto

Abaixo uma lista de checks para garantir que tudo está ok.

### 6.1. Testes básicos de infraestrutura

1. **Contêineres sobem sem erro**
   - Comando:
   - Esperado:
     - Os serviços `db`, `backend`, `frontend` iniciam sem mensagens de erro críticas.
     - O backend loga algo como: `Backend rodando na porta 4000`.

2. **Healthcheck da API**
   - Acessar:
     - `http://localhost:4000/health`
   - Resultado esperado:
     ```json
     {
       "status": "ok"
     }
     ```
   - Se der erro 500, verificar logs do container `backend` e conexão com o Postgres.

3. **Conexão com banco e criação de tabela**
   - Ao subir o backend pela primeira vez, ele executa o `CREATE TABLE IF NOT EXISTS challenges`.
   - Teste:
     - Inserir um desafio pelo frontend ou via API (veja itens seguintes).
     - Verificar no banco se a tabela `challenges` existe e se há registros.

---

### 6.2. Testes da API (CRUD)

Você pode usar `curl`, Postman ou Insomnia para testar os endpoints.

#### 6.2.1. Listar desafios (GET)

- Request:
  ```bash
  curl http://localhost:4000/api/challenges
  ```
- Esperado:
  - Status HTTP: `200`
  - Corpo: array JSON (vazio ou com desafios).

#### 6.2.2. Criar desafio (POST)

- Request:
  ```bash
  curl -X POST http://localhost:4000/api/challenges     -H "Content-Type: application/json"     -d '{
      "title": "Estudar Docker",
      "description": "Estudar Docker e Docker Compose por 1 hora",
      "difficulty": "medio",
      "status": "pendente",
      "category": "estudos",
      "start_date": "2025-01-01",
      "end_date": "2025-01-10",
      "progress": 0
    }'
  ```
- Esperado:
  - Status HTTP: `201`
  - Corpo: objeto JSON do desafio criado, com `id` preenchido.

#### 6.2.3. Atualizar desafio (PUT)

- Primeiro, crie um desafio (via frontend ou POST anterior) e pegue o `id`.
- Request:
  ```bash
  curl -X PUT http://localhost:4000/api/challenges/1     -H "Content-Type: application/json"     -d '{
      "title": "Estudar Docker (atualizado)",
      "description": "Agora estudar 2 horas por dia",
      "difficulty": "dificil",
      "status": "em_andamento",
      "category": "estudos",
      "start_date": "2025-01-01",
      "end_date": "2025-01-20",
      "progress": 30
    }'
  ```
- Esperado:
  - Status HTTP: `200`
  - Corpo: desafio atualizado com os novos valores.

#### 6.2.4. Remover desafio (DELETE)

- Request:
  ```bash
  curl -X DELETE http://localhost:4000/api/challenges/1
  ```
- Esperado:
  - Status HTTP: `204` (sem corpo).
  - Nova chamada `GET /api/challenges` não deve conter o item removido.

#### 6.2.5. Erro de item inexistente

- Request para um ID que não exista:
  ```bash
  curl -i -X DELETE http://localhost:4000/api/challenges/9999
  ```
- Esperado:
  - Status HTTP: `404`
  - Corpo: JSON com `{ "error": "Desafio não encontrado" }`.

---

### 6.3. Testes do frontend

1. **Carregamento inicial**
   - Acessar: `http://localhost:3000`
   - Esperado:
     - Página com título “App de Desafios”.
     - Formulário com campos de título, descrição, dificuldade, status, categoria, datas e slider de progresso.
     - Lista de desafios (vazia ou contendo itens já criados).

2. **Criação de desafio via UI**
   - Preencher o formulário e clicar em **Criar desafio**.
   - Esperado:
     - O item aparece na lista logo abaixo, com título, categoria, dificuldade, status e progresso.

3. **Edição via UI**
   - Clicar em **Editar** em um desafio.
   - Esperado:
     - Os campos do formulário são preenchidos com os dados selecionados.
   - Alterar algo (ex.: progresso de 0 para 50%) e clicar em **Salvar alterações**.
   - Esperado:
     - O item na lista é atualizado com os novos valores.

4. **Exclusão via UI**
   - Clicar em **Excluir** em um desafio.
   - Confirmar na caixa de diálogo.
   - Esperado:
     - O item some da lista.
     - Um novo `GET /api/challenges` não retorna o item removido.

---

### 6.4. Testes de persistência e resiliência

1. **Persistência de dados**
   - Criar alguns desafios.
   - Parar os containers:
   - Esperado:
     - Os desafios criados anteriormente **continuam lá** (volume `db_data` do Postgres mantém os dados).

2. **Logs e erros**
   - Inspecionar logs se algo falhar:
     ```
   - Verificar mensagens de erro de conexão com banco, migração, etc.

---

## 7. Dicas para evolução do projeto

Algumas ideias de próximos passos:

- Adicionar autenticação (JWT) e usuários.
- Filtrar desafios por status ou categoria no frontend.
- Criar paginação na listagem de desafios.
- Adicionar testes automatizados (Jest, Vitest).
- Containerizar para produção (otimizar Dockerfile, variáveis de ambiente, etc.).
- Deploy no Kubernetes (EKS, GKE, etc.).

---

Qualquer ajuste na stack (NestJS, Next.js, outro banco, etc.) pode ser feito facilmente em cima dessa base.

OBS: Reocmendado utilizar um DNS publicoe/ou IP publico para validar, Para mostrar o sistema funcionando.
