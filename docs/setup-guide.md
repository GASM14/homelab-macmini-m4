# Setup Guide – Homelab Mac Mini M4

This guide walks through the setup of the full monitoring and security stack.

## Prerequisites
- macOS with Colima or Docker Desktop installed
- Tailscale account (with a reusable auth key)
- Git
- At least 12 GB of RAM allocated to the VM

---

## Step-by-step

### 1. Clone this repository

```bash
git clone https://github.com/GASM14/homelab-macmini-m4.git
cd homelab-macmini-m4
```

### 2. Configure environment variables

Copy the global `.env.example` to `.env` and fill in your secrets:

```bash
cp .env.example .env
nano .env
```

You also need to configure the `services/logtide/.env`:

```bash
cd services/logtide
cp .env.example .env
nano .env
```

### 3. Start the services

You can start all services individually, or use the provided script:

```bash
# Example: start Logtide
docker compose -f services/logtide/docker-compose.simple.yml up -d

# Start Suricata
docker compose -f services/suricata/docker-compose.suricata.yml up -d

# Start Netdata
docker compose -f services/netdata/docker-compose.yml up -d
```

Or, use the update script to start everything:

```bash
./scripts/update-all.sh
```

### 4. Verify the services are running

```bash
./scripts/health-check.sh
```

### 5. Access the web interfaces (via Tailscale)

| Service | URL (Tailscale) |
| :--- | :--- |
| **Logtide** | `https://logtide.tailscale-host.ts.net` |
| **Netdata** | `https://netdata.tailscale-host.ts.net` |
| **Suricata** | (CLI only, or via logs) |
| **Pi-hole** | `https://pihole.tailscale-host.ts.net/admin` |
| **Uptime Kuma** | `https://uptime-kuma.tailscale-host.ts.net` |

---

## 🧪 Troubleshooting

### ❌ Suricata is restarting

Check the logs:

```bash
docker logs suricata --tail 50
```

Common causes:

- Interface `eth0` not found → try `-i tun0` in the `docker-compose.suricata.yml`.
- Permission errors on `suricata.yaml` → ensure the file is not mounted as `:ro`.

### ❌ Vector cannot connect to Logtide

- Check if the IP in `uri` is correct.
- Verify that the API key is valid and has the `ingest` permission.
- Ensure both containers are on the same Docker network:

```bash
docker inspect vector | grep Network
docker inspect logtide-simple-backend | grep Network
```

### ❌ Logtide shows `401` or `404` in the UI

- Make sure you have created an API key with the correct permissions.
- Check that `API_KEY_SECRET` and `INTERNAL_API_KEY` are set correctly in `docker-compose.simple.yml`.

### ❌ "Connection refused" when accessing a service

- Confirm that the service is running (`docker ps`).
- Check that the Tailscale sidecar is healthy.
- Verify the service is listening on `0.0.0.0` (not `127.0.0.1`).

---

## 📦 Backup and maintenance

Use the provided scripts:

```bash
./scripts/backup.sh          # backup all configs
./scripts/update-all.sh      # pull and restart all services
./scripts/health-check.sh    # check all container health
```

You can schedule these with `cron` or `launchd`.

---

## 🛡️ Security best practices

- Never commit `.env` files or any file containing real secrets.
- Rotate API keys periodically.
- Keep Tailscale and Docker updated.
- Use separate Tailscale auth keys for each service (if possible).

---

## 💬 Need help?

Open an issue on GitHub or reach out via email or LinkedIn.
