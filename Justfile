# Development stack commands for devpool (Bitcoin signet OP_TRUE + Hydrapool + Mempool)

compose := "docker compose -f devpool.yml"
project := "devpool"
host := `hostname -I | awk '{print $1}'`

# Show status and URLs (default)
default: status

# Show status and URLs
status:
    @echo "Devpool URLs:"
    @echo "  Welcome:  http://{{host}}:8080"
    @echo "  Stratum:  stratum+tcp://{{host}}:3333"
    @echo "  Grafana:  http://{{host}}:3000"
    @echo "  Mempool:  http://{{host}}:8081"
    @echo ""
    @docker compose -p {{project}} ps 2>/dev/null || echo "(not running)"
    @echo ""
    @echo "Run 'just --list' for available commands."

alias help := status

# Start all services
up:
    {{compose}} up -d
    @echo "Devpool ready: http://localhost:8080 or http://$(hostname -I | awk '{print $1}'):8080"

# Stop all services
down:
    docker compose -p {{project}} down

# Restart all services
restart:
    docker compose -p {{project}} down
    {{compose}} up -d
    @echo "Devpool ready: http://localhost:8080 or http://$(hostname -I | awk '{print $1}'):8080"

# Stop all services and erase data volumes
purge:
    docker compose -p {{project}} down -v

# Follow logs (all services)
logs *args:
    docker compose -p {{project}} logs -f {{args}}

alias ps := status

# Set pool difficulty (e.g., `just difficulty 14000` for ~2 TH/s)
difficulty value="":
    #!/bin/bash
    if [ -z "{{value}}" ]; then
        echo "Usage: just difficulty <value>"
        echo ""
        echo "Difficulty for ~1 block every 30 seconds:"
        echo "  7000    ~1 TH/s"
        echo "  35000   ~5 TH/s"
        echo "  70000   ~10 TH/s"
        echo "  700000  ~100 TH/s"
        exit 1
    fi
    sed -i 's/start_difficulty = [0-9]*/start_difficulty = {{value}}/' devpool.yml
    sed -i 's/minimum_difficulty = [0-9]*/minimum_difficulty = {{value}}/' devpool.yml
    echo "Difficulty set to {{value}}. Restart with: just restart"
