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

# Set pool difficulty (e.g., `just difficulty 15000` for ~1 TH/s)
difficulty value="":
    #!/bin/bash
    if [ -z "{{value}}" ]; then
        echo "Usage: just difficulty <value>"
        echo ""
        echo "Difficulty for ~1 block/min at various hashrates:"
        echo "  7500    ~0.5 TH/s"
        echo "  15000   ~1 TH/s"
        echo "  70000   ~5 TH/s"
        echo "  140000  ~10 TH/s"
        exit 1
    fi
    sed -i 's/start_difficulty = [0-9]*/start_difficulty = {{value}}/' devpool.yml
    sed -i 's/minimum_difficulty = [0-9]*/minimum_difficulty = {{value}}/' devpool.yml
    echo "Difficulty set to {{value}}. Restart with: just down && just up"
