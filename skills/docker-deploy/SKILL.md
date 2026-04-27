---
name: docker-deploy
description: Containerization and deployment workflows covering Dockerfiles, Docker Compose, multi-stage builds, health checks, image optimization, and production deployment patterns. This skill should be used when containerizing applications, writing Dockerfiles, setting up Docker Compose stacks, optimizing images, or deploying containerized services.
---

# Docker Deploy

This skill provides structured guidance for containerizing applications with Docker, from writing efficient Dockerfiles through multi-service Compose stacks to production deployment patterns.

## Prerequisites

- Docker installed (20.10+)
- Docker Compose (v2, included with Docker Desktop)
- Basic understanding of containers and images

## When to Use This Skill

- Writing or optimizing Dockerfiles
- Setting up Docker Compose for multi-service applications
- Implementing multi-stage builds for smaller images
- Configuring health checks for container orchestration
- Debugging container issues
- Preparing containers for production deployment

## Dockerfile Patterns

### Multi-Stage Build Template

```dockerfile
# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production

# Stage 2: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 3: Production
FROM node:20-alpine AS runner
WORKDIR /app

# Security: Run as non-root user
RUN addgroup --system --gid 1001 appgroup && \
    adduser --system --uid 1001 appuser

# Copy only what's needed
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node", "dist/server.js"]
```

### Language-Specific Patterns

#### Python (FastAPI/Flask)

```dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH

RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

#### Go

```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /server ./cmd/server

FROM scratch
COPY --from=builder /server /server
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

EXPOSE 8080
ENTRYPOINT ["/server"]
```

### Dockerfile Best Practices

| Practice | Why | How |
|----------|-----|-----|
| Pin base image tags | Reproducibility | `node:20.11-alpine` not `node:latest` |
| Use `.dockerignore` | Smaller context, faster builds | Exclude `node_modules`, `.git`, `docs` |
| Order layers least→most changed | Cache efficiency | Copy deps before source code |
| Multi-stage builds | Small final image | Build in one stage, copy artifacts |
| Non-root user | Security | `USER appuser` in final stage |
| One process per container | Orchestration | Don't run app + cron in same container |
| `COPY --chown` | Avoid chown layer | `COPY --chown=appuser:appgroup . .` |

### .dockerignore

```
.git
.github
node_modules
npm-debug.log
Dockerfile
docker-compose*.yml
.dockerignore
.env
.env.*
*.md
.vscode
.idea
coverage
dist
```

## Docker Compose

### Multi-Service Stack

```yaml
# docker-compose.yml
version: "3.9"

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: runner
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://app:secret@postgres:5432/appdb
      - REDIS_URL=redis://redis:6379
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:3000/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 15s
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: "1.0"

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: app
      POSTGRES_PASSWORD: secret
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app -d appdb"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes --maxmemory 256mb --maxmemory-policy allkeys-lru
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certs:/etc/nginx/certs:ro
    depends_on:
      app:
        condition: service_healthy
    restart: unless-stopped

volumes:
  postgres_data:
  redis_data:
```

### Development Override

```yaml
# docker-compose.override.yml (auto-merged with docker-compose.yml)
version: "3.9"

services:
  app:
    build:
      target: builder
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
    command: npm run dev
    ports:
      - "3000:3000"
      - "9229:9229"  # Debug port

  postgres:
    ports:
      - "5432:5432"  # Expose for local tools
```

### Compose Profiles (Optional Services)

```yaml
services:
  # Only starts with: docker compose --profile monitoring up
  prometheus:
    image: prom/prometheus:latest
    profiles: ["monitoring"]
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    profiles: ["monitoring"]
    ports:
      - "3001:3000"
```

## Health Checks

### Health Check Patterns

```dockerfile
# HTTP endpoint
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# TCP port check
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD nc -z localhost 5432 || exit 1

# Custom script (most flexible)
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD /app/healthcheck.sh
```

### Application Health Endpoint

```typescript
// /health endpoint should check all dependencies
app.get('/health', async (req, res) => {
  const checks = {
    database: await checkDatabase(),
    redis: await checkRedis(),
    storage: await checkStorage(),
  };

  const healthy = Object.values(checks).every(c => c.status === 'ok');

  res.status(healthy ? 200 : 503).json({
    status: healthy ? 'healthy' : 'degraded',
    checks,
    timestamp: new Date().toISOString(),
  });
});
```

## Production Deployment

### Image Optimization Checklist

- [ ] Using multi-stage build (build artifacts only in final image)
- [ ] Using Alpine or distroless base images
- [ ] Pinned image tags (not `latest`)
- [ ] `.dockerignore` excludes unnecessary files
- [ ] Layers ordered for cache efficiency
- [ ] Running as non-root user
- [ ] No secrets in image (use environment variables or secrets)
- [ ] Health check configured
- [ ] Single process per container
- [ ] Proper signal handling (PID 1, `exec` form of CMD)

### Environment Configuration

```yaml
# Use .env file for local development (never commit)
# .env
POSTGRES_PASSWORD=local_dev_password
JWT_SECRET=local_dev_secret

# Use Docker secrets or cloud secret managers for production
# docker-compose.prod.yml
services:
  app:
    secrets:
      - db_password
      - jwt_secret
    environment:
      DATABASE_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    external: true
  jwt_secret:
    external: true
```

### Resource Limits

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: "2.0"
          memory: 1G
        reservations:
          cpus: "0.5"
          memory: 256M
```

## Debugging

### Common Issues

| Problem | Diagnosis | Fix |
|---------|-----------|-----|
| Container exits immediately | `docker logs <container>` | Check CMD/ENTRYPOINT, missing env vars |
| Build cache invalid | `docker build --no-cache` | Check layer order, COPY contexts |
| Port already in use | `docker ps` + `lsof -i :PORT` | Change host port mapping |
| Permission denied | Check USER directive | Fix file ownership with `COPY --chown` |
| OOM killed | `docker stats` | Increase memory limit, optimize app |
| Can't reach service | `docker network inspect` | Use service names, not localhost |

### Debug Commands

```bash
# View logs
docker compose logs -f app

# Shell into running container
docker compose exec app sh

# Run one-off command
docker compose run --rm app npm run migrate

# Inspect container details
docker inspect <container>

# Resource usage
docker stats

# Image layers and sizes
docker history <image>

# Network troubleshooting
docker compose exec app ping postgres
docker compose exec app nslookup postgres
```

## Tips

- Always use multi-stage builds — your production image should be 10-100x smaller than your build image
- Use `docker compose config` to validate and view the merged compose file
- Use `docker scout` or `trivy` to scan images for vulnerabilities before deploying
- Tag images with both version and git SHA: `myapp:1.2.0-gabcdef1`
- Use `depends_on` with `condition: service_healthy` to ensure startup order
- Never store secrets in Dockerfiles or compose files — use secrets management
- Test health checks manually: `docker inspect --format='{{.State.Health.Status}}' <container>`

## Cline Workflow Notes

1. **Install location**: Copy this skill directory to `.cline/skills/docker-deploy/` (project-level) or `~/.cline/skills/docker-deploy/` (global)
2. **Activation**: Cline will suggest this skill when you need containerization, Dockerfiles, or deployment configurations
3. **Progressive loading**: Metadata is always available; detailed Docker patterns and Compose examples load on demand via `use_skill`
