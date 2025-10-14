#!/bin/sh
# Network isolation enforcement for Docker Security Lab
# Blocks vulnerable apps from accessing the internet

set -e
trap 'echo "Error applying iptables rules on line $LINENO" >&2' ERR

echo "Setting up network isolation rules..."

# Wait for Docker networks to be ready
echo "Waiting for Docker networks..."
TIMEOUT=30
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
    if iptables -L DOCKER-USER >/dev/null 2>&1; then
        echo "Docker networks ready"
        break
    fi
    sleep 1
    ELAPSED=$((ELAPSED + 1))
done

if [ $ELAPSED -ge $TIMEOUT ]; then
    echo "Timeout waiting for Docker networks" >&2
    exit 1
fi

# Clear any existing rules (prevent duplicates on restart)
echo "Cleaning up old rules..."
iptables -D DOCKER-USER -s 172.22.0.0/16 -d 172.22.0.0/16 -j ACCEPT 2>/dev/null || true
iptables -D DOCKER-USER -s 172.22.0.0/16 -d 172.20.0.0/16 -j ACCEPT 2>/dev/null || true
iptables -D DOCKER-USER -s 172.22.0.0/16 -d 172.21.0.0/16 -j ACCEPT 2>/dev/null || true
iptables -D DOCKER-USER -s 172.22.0.0/16 ! -d 172.0.0.0/8 -j DROP 2>/dev/null || true
iptables -D DOCKER-USER -s 172.21.0.0/16 ! -d 172.0.0.0/8 -j DROP 2>/dev/null || true
ip6tables -D DOCKER-USER -s fd00::/8 ! -d fd00::/8 -j DROP 2>/dev/null || true

# Apply fresh rules
echo "Applying isolation rules..."

# Allow internal Docker communication first (order matters)
iptables -I DOCKER-USER -s 172.22.0.0/16 -d 172.22.0.0/16 -j ACCEPT
iptables -I DOCKER-USER -s 172.22.0.0/16 -d 172.20.0.0/16 -j ACCEPT  
iptables -I DOCKER-USER -s 172.22.0.0/16 -d 172.21.0.0/16 -j ACCEPT

# Block monitoring-network from internet
iptables -I DOCKER-USER -s 172.22.0.0/16 ! -d 172.0.0.0/8 -j DROP

# Block vulnerable-network from internet (defense in depth)
iptables -I DOCKER-USER -s 172.21.0.0/16 ! -d 172.0.0.0/8 -j DROP

# IPv6 blocking
ip6tables -I DOCKER-USER -s fd00::/8 ! -d fd00::/8 -j DROP

# Verify rules applied
echo "Verifying rules..."
if ! iptables -L DOCKER-USER -n | grep -q "172.22.0.0/16"; then
    echo "Failed to verify iptables rules" >&2
    exit 1
fi

echo "Network isolation rules applied successfully:"
echo "- Monitoring network (172.22.0.0/16) blocked from internet"
echo "- Vulnerable network (172.21.0.0/16) blocked from internet"  
echo "- Internal Docker communication allowed (172.0.0.0/8)"

# Keep container running
tail -f /dev/null

