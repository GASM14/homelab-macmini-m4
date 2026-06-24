# Setup Guide – Homelab Mac Mini M4

This guide walks through the setup of the full monitoring and security stack.

## Prerequisites
- macOS with Colima or Docker Desktop installed
- Tailscale account (with an auth key)
- Git

## Steps
1. Clone this repository
2. Copy `.env.example` to `.env` and fill in your secrets
3. Start each service with:
   ```bash
   docker compose -f services/<service>/docker-compose.yml up -d
   ```
4. Verify each service is healthy:
docker ps

## Service-specific notes
- Logtide: requires .env inside services/logtide/ with DB credentials and API keys.
- Suricata: needs a Tailscale auth key to expose the web interface.
- Netdata: already integrated with Tailscale.
- Vector: configured to send logs to Logtide; check vector.toml for API key.
- For detailed troubleshooting, check the logs with docker logs <container>.

## ✅ Verificar se todos os ficheiros foram copiados

Executa:

```bash
tree /Volumes/CrucialX9/repo
```

.
├── .env.example
├── .gitignore
├── docs
│   └── setup-guide.md
├── scripts
└── services
    ├── aiostreams
    │   └── docker-compose.yml
    ├── filebrowser
    │   └── docker-compose.yml
    ├── glances
    │   └── docker-compose.yml
    ├── homer
    │   └── docker-compose.yml
    ├── logtide
    │   ├── .env.example
    │   ├── docker-compose.simple.yml
    │   └── vector
    │       └── vector.toml
    ├── mealie
    │   └── docker-compose.yml
    ├── netdata
    │   └── docker-compose.yml
    ├── nzbdav
    │   └── docker-compose.yml
    ├── photoprism
    │   └── docker-compose.yml
    ├── pihole
    │   └── docker-compose.yml
    ├── suricata
    │   ├── docker-compose.suricata.yml
    │   ├── local.rules   # (se copiaste para rules/)
    │   ├── rules
    │   │   └── local.rules
    │   └── suricata.yaml
    └── uptime-kuma
        └── docker-compose.yml
