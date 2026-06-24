#!/bin/bash
# Update all services

SERVICES_DIR="/Volumes/CrucialX9/repo/services"

echo "🔄 Starting update of all services at $(date)"

for service in "$SERVICES_DIR"/*; do
    if [ -f "$service/docker-compose.yml" ]; then
        echo "⬆️  Updating service: $(basename "$service")"
        docker compose -f "$service/docker-compose.yml" pull
        docker compose -f "$service/docker-compose.yml" up -d
    elif [ -f "$service/docker-compose.simple.yml" ]; then
        echo "⬆️  Updating service: $(basename "$service")"
        docker compose -f "$service/docker-compose.simple.yml" pull
        docker compose -f "$service/docker-compose.simple.yml" up -d
    fi
done

echo "✅ All services updated successfully"
