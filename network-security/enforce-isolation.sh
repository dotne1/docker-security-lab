#!/bin/sh
# Network isolation enforcement for Docker Security Lab
# Blocks vulnerable apps from accessing the internet

echo "Setting up network isolation rules..."

# Wait for Docker networks to be ready
sleep 5

# Block specific vulnerable app IPs from reaching internet
# These IPs are typically assigned to dvwa, webgoat, juiceshop
# Block their traffic to non-Docker destinations (i.e., internet)

# Get container IPs dynamically (if possible) or use static ranges
# Block monitoring-network vulnerable app range (where they get routable IPs)
iptables -I DOCKER-USER -s 172.22.0.0/16 -d 172.22.0.0/16 -j ACCEPT
iptables -I DOCKER-USER -s 172.22.0.0/16 -d 172.20.0.0/16 -j ACCEPT  
iptables -I DOCKER-USER -s 172.22.0.0/16 -d 172.21.0.0/16 -j ACCEPT
iptables -I DOCKER-USER -s 172.22.0.0/16 ! -d 172.0.0.0/8 -j DROP

# Also block vulnerable-network (defense in depth)
iptables -I DOCKER-USER -s 172.21.0.0/16 ! -d 172.0.0.0/8 -j DROP

# IPv6
ip6tables -I DOCKER-USER -s fd00::/8 ! -d fd00::/8 -j DROP

echo "Network isolation rules applied:"
echo "- Monitoring network (172.22.0.0/16) blocked from internet"
echo "- Vulnerable network (172.21.0.0/16) blocked from internet"  
echo "- Internal Docker communication allowed (172.0.0.0/8)"

# Keep container running
tail -f /dev/null

