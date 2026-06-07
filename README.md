# Hermes Agent - Docker

Configuración Docker para ejecutar [Hermes Agent](https://hermes-agent.nousresearch.com/) de NousResearch usando tu configuración existente.

## 📁 Estructura

| Archivo | Descripción |
|---------|-------------|
| `docker-compose.yml` | Configuración principal del servicio |
| `Dockerfile` | Extensión de la imagen oficial (opcional) |
| `start.sh` | Script interactivo de inicio |
| `.env.example` | Plantilla de variables de entorno |

## 🚀 Uso Rápido

### Opción 1: Script interactivo (recomendado)

```bash
chmod +x start.sh
./start.sh
```

### Opción 2: Docker Compose directo

```bash
# Iniciar gateway en background
docker compose up -d

# Ver logs
docker compose logs -f hermes

# Detener
docker compose down
```

### Opción 3: Docker run (sin Compose)

```bash
# Gateway mode
docker run -d \
  --name hermes-agent \
  --restart unless-stopped \
  -v ~/.hermes:/opt/data \
  -p 8642:8642 \
  nousresearch/hermes-agent gateway run

# CLI interactivo
docker run -it --rm -v ~/.hermes:/opt-data nousresearch/hermes-agent
```

## 📂 Datos Persistidos

Tu configuración se monta desde `~/.hermes` (host) a `/opt/data` (contenedor):

```
~/.hermes/
├── .env           # API keys y secretos
├── config.yaml    # Configuración principal
├── SOUL.md        # Personalidad del agente
├── sessions/      # Historial de conversaciones
├── memories/      # Memoria persistente
├── skills/        # Skills instaladas
└── ...
```

## 🌐 Acceso

- **Gateway**: http://localhost:8642
- **Documentación**: https://hermes-agent.nousresearch.com/

## 🔄 Actualizar

```bash
./start.sh  # Opción 5
# o manualmente:
docker pull nousresearch/hermes-agent:latest
docker compose up -d
```

## 🛠️ Personalización

Edita `docker-compose.yml` para añadir:
- GPUs (descomenta sección `deploy`)
- Redes adicionales
- Variables de entorno
- Volúmenes extras
