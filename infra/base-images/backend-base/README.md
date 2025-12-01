# Backend Base Image

Imagem base segura para aplicações Node.js backend.

## Características de Segurança

- Base Alpine Linux (imagem minimal)
- Usuário não-root (nodejs:1001)
- dumb-init para gerenciamento de processos
- Variáveis de ambiente de produção
- Sem ferramentas de desenvolvimento

## Uso

```dockerfile
FROM seu-registry/backend-base:latest

COPY --chown=nodejs:nodejs package*.json ./
RUN npm ci --only=production && npm cache clean --force

COPY --chown=nodejs:nodejs . .

CMD ["node", "src/index.js"]
```

## Build

```bash
docker build -t seu-registry/backend-base:20-alpine3.19 .
```

## Scan de Vulnerabilidades

```bash
docker scan seu-registry/backend-base:20-alpine3.19
```

