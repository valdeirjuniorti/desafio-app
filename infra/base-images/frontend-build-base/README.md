# Frontend Build Base Image

Imagem base segura para build de aplicações frontend (React/Vite).

## Características de Segurança

- Base Alpine Linux (imagem minimal)
- Usuário não-root (nodejs:1001)
- dumb-init para gerenciamento de processos
- Variáveis de ambiente de produção
- Otimizada para builds

## Uso

```dockerfile
FROM seu-registry/frontend-build-base:latest AS build

COPY --chown=nodejs:nodejs package*.json ./
RUN npm ci && npm cache clean --force

COPY --chown=nodejs:nodejs . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
```

## Build

```bash
docker build -t seu-registry/frontend-build-base:20-alpine3.19 .
```

## Scan de Vulnerabilidades

```bash
docker scan seu-registry/frontend-build-base:20-alpine3.19
```

