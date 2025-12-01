FROM backend-base:20-alpine3.19

COPY --chown=nodejs:nodejs package*.json ./
RUN npm ci --only=dev && \
    npm cache clean --force

COPY --chown=nodejs:nodejs src ./src

ENV PORT=4000

EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:4000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

CMD ["node", "src/index.js"]
