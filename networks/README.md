# Network Configuration

This directory contains network-related configurations for the security lab.

## Networks Overview

The security lab uses three isolated Docker networks:

### 1. `pentest-network` (172.20.0.0/16)
- **Purpose**: Main network for penetration testing tools
- **Internet Access**: Yes
- **Services**: Kali workstation, honeypots

### 2. `vulnerable-network` (172.21.0.0/16)
- **Purpose**: Isolated network for vulnerable applications
- **Internet Access**: No (internal only)
- **Services**: DVWA, WebGoat, Juice Shop
- **Security**: Applications cannot reach external networks

### 3. `monitoring-network` (172.22.0.0/16)
- **Purpose**: Monitoring and logging infrastructure
- **Internet Access**: Yes (limited)
- **Services**: Elasticsearch, Kibana, log collectors

## Network Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     Host Machine                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │         pentest-network (172.20.0.0/16)               │  │
│  │                                                         │  │
│  │  ┌──────────────┐  ┌─────────────┐  ┌──────────────┐  │  │
│  │  │ Kali         │  │ SSH         │  │ Future       │  │  │
│  │  │ Workstation  │  │ Honeypot    │  │              │  │  │
│  │  └──────────────┘  └─────────────┘  └──────────────┘  │  │
│  │         │                                     │         │  │
│  └─────────┼─────────────────────────────────────┼─────────┘  │
│            │                                     │            │
│  ┌─────────┼─────────────────────────────────────┼─────────┐  │
│  │         │   vulnerable-network (ISOLATED)     │         │  │
│  │         │       (172.21.0.0/16)               │         │  │
│  │  ┌──────▼─────┐  ┌──────────┐  ┌───────────┐ │         │  │
│  │  │ DVWA       │  │ WebGoat  │  │ Juice     │ │         │  │
│  │  │            │  │          │  │ Shop      │ │         │  │
│  │  └────────────┘  └──────────┘  └───────────┘ │         │  │
│  │         │              │              │       │         │  │
│  └─────────┼──────────────┼──────────────┼───────┘         │  │
│            │              │              │                 │  │
│  ┌─────────┼──────────────┼──────────────┼───────┐         │  │
│  │         │   monitoring-network         │       │         │  │
│  │         │     (172.22.0.0/16)          │       │         │  │
│  │  ┌──────▼──────┐           ┌───────────▼────┐ │         │  │
│  │  │ Elastic-    │◄──────────┤ Kibana         │ │         │  │
│  │  │ search      │           │                │ │         │  │
│  │  └─────────────┘           └────────────────┘ │         │  │
│  └─────────────────────────────────────────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## Custom Network Configurations

You can add custom network configurations here:

### Example: Adding a DMZ Network

```yaml
# Add to docker-compose.yml
networks:
  dmz-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.23.0.0/16
```

### Example: Network Segmentation

Create custom networks for different testing scenarios:

```bash
# Create a network for IoT device testing
docker network create --driver bridge --subnet 172.24.0.0/16 iot-network

# Create a network for mobile app backend testing
docker network create --driver bridge --subnet 172.25.0.0/16 mobile-backend-network
```

## Security Best Practices

1. **Isolation**: Keep vulnerable apps in `internal` networks (no internet)
2. **Segmentation**: Separate different types of testing environments
3. **Monitoring**: All networks should connect to monitoring network
4. **No Default Bridge**: Don't use Docker's default bridge network
5. **Firewall Rules**: Consider adding iptables rules for extra protection

## Troubleshooting

### Check network configuration:
```bash
docker network ls
docker network inspect pentest-network
```

### View container network connections:
```bash
docker inspect kali-workstation | grep -A 20 Networks
```

### Test connectivity between containers:
```bash
docker exec kali-workstation ping -c 3 dvwa
```

### Check for network conflicts:
```bash
ip addr show
# Look for conflicts with 172.20-25.0.0/16 ranges
```

## Advanced Topics

- **VPN Integration**: Connect external devices to the lab
- **Traffic Analysis**: Capture and analyze network traffic with tcpdump
- **Network Simulation**: Simulate network conditions (latency, packet loss)
- **802.11 Testing**: Add wireless network testing capabilities

See the main [README.md](../README.md) for more information.

