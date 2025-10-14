# Network Security Enforcer

Automatically enforces network isolation for vulnerable applications.

## Purpose

This container runs with `NET_ADMIN` capability and sets up iptables rules on the Docker host to block vulnerable applications from accessing the internet while allowing:
- Port publishing to host (for browser access)
- Internal Docker network communication
- Kali workstation access to vulnerable apps

## How It Works

1. Container starts with host network mode and NET_ADMIN capability
2. Applies iptables rules to block subnet 172.21.0.0/16 (vulnerable-network) from internet
3. Allows all internal Docker communication (172.0.0.0/8)
4. Keeps running to maintain rules

## Security Rules Applied

```
iptables -I DOCKER-USER -s 172.21.0.0/16 ! -d 172.0.0.0/8 -j DROP
```

This blocks traffic FROM vulnerable-network subnet TO any non-Docker destination (i.e., internet).

## Verification

After starting the stack:

```bash
# Should FAIL (blocked by iptables)
docker exec dvwa ping -c 2 8.8.8.8

# Should WORK (internal Docker network)
docker exec kali-workstation ping -c 2 dvwa

# Should WORK (port publishing)
curl http://localhost:8080
```

