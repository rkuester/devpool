# Development stack commands for devpool (Bitcoin signet OP_TRUE + Hydrapool + Mempool)

compose := "docker compose -f devpool.yml"
project := "devpool"

# Start all services
up:
    {{compose}} up -d
    @echo "Devpool ready: http://localhost:8080 or http://$(hostname -I | awk '{print $1}'):8080"

# Stop all services
down:
    docker compose -p {{project}} down

# Stop all services and erase data volumes
purge:
    docker compose -p {{project}} down -v

# Follow logs (all services)
logs *args:
    docker compose -p {{project}} logs -f {{args}}

# Show service status
ps:
    docker compose -p {{project}} ps -a
