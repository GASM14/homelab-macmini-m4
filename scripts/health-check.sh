#!/bin/bash
# Health check for all containers

echo "🩺 Checking health of all containers at $(date)"

containers=$(docker ps --format "{{.Names}}")

for container in $containers; do
    status=$(docker inspect --format='{{.State.Status}}' "$container")
    health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "N/A")
    echo "📦 $container -> Status: $status | Health: $health"
done

echo "✅ Health check completed"
