# Docker Security Lab

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Required-blue.svg)](https://www.docker.com/)
[![Security: Educational](https://img.shields.io/badge/Security-Educational%20Only-red.svg)](SECURITY.md)

Isolated Docker environment for learning penetration testing. Kali Linux + vulnerable apps + monitoring, all in containers.

> **⚠️ WARNING**: Intentionally vulnerable applications. Never expose to the internet. Local/lab use only. See [SECURITY.md](SECURITY.md).

## What's Inside

- **Kali Linux** - nmap, metasploit, sqlmap, nikto, dirb, hydra, john, netcat, curl, wget, git, nano, vim (with all dependencies)
- **Vulnerable Apps** - DVWA, WebGoat, Juice Shop
- **Monitoring** - ELK stack (Elasticsearch + Kibana)
- **Honeypots** - SSH and web honeypots
- **Grok-Code AI Assistant** - AI-powered security analysis and education

## Quick Start

```bash
# Clone and setup
git clone https://github.com/dotne1/docker-security-lab.git
cd docker-security-lab
./scripts/setup.sh

# Start everything (this will take 5-10 minutes for tool installation)
docker-compose up -d

# Wait for Kali tools to install, then access
docker exec -it kali-workstation /bin/bash
```

**Note**: First startup takes 5-10 minutes while Kali installs tools. Check `docker-compose logs kali-workstation` for progress.

### Access Points

| Service | URL | Credentials |
|---------|-----|-------------|
| DVWA | http://localhost:8080 | admin / password |
| WebGoat | http://localhost:8081 | Register account |
| Juice Shop | http://localhost:8082 | - |
| Kibana | http://localhost:5601 | - |
| Grok-Code API | http://localhost:8180 | API key required |
| Kali Linux | `docker exec -it kali-workstation bash` | - |

## Basic Usage

**From Kali, scan vulnerable apps:**
```bash
docker exec kali-workstation nmap -sV dvwa
docker exec kali-workstation nikto -h http://dvwa
```

**Try DVWA SQL injection:**
1. Go to http://localhost:8080
2. Login (admin/password)
3. Click "Create / Reset Database"
4. SQL Injection section
5. Try payload: `1' OR '1'='1`

**Access Metasploit:**
```bash
docker exec -it kali-workstation msfconsole
```

## Grok-Code AI Integration

This lab includes professional integration with xAI's Grok-Code models for AI-powered security assistance.

**Features**:
- Code vulnerability analysis
- Security concept explanations  
- Educational exploit suggestions
- Payload generation for testing
- OpenAI-compatible API endpoints

**Setup**: Add your Grok API key to `.env` file (see [grok-code/README.md](grok-code/README.md))

## Project Structure

```
docker-security-lab/
├── docker-compose.yml          # Main config
├── kali/                       # Kali workspace (persists)
├── vulnerable-apps/            # Add custom vulnerable apps
├── honeypot/                   # Honeypot logs and content
├── monitoring/                 # ELK stack data
└── scripts/                    # Helper scripts
```

Each directory has its own README with specific details.

## Network Architecture

Three isolated networks:
- **pentest-network** - Kali and tools (has internet)
- **vulnerable-network** - DVWA, WebGoat, Juice Shop (no internet)
- **monitoring-network** - ELK stack

Vulnerable apps can't phone home. Everything logged.

## Common Commands

```bash
# Check status
./scripts/status.sh

# Stop everything
docker-compose down

# Remove all data (destructive!)
docker-compose down -v

# Update images
docker-compose pull && docker-compose up -d

# View logs
docker-compose logs -f [service-name]
```

## Troubleshooting

**Containers won't start:**
```bash
docker ps  # Check what's running
docker stats  # Check resources
docker logs [container-name]  # Check errors
```

**Permission issues:**
```bash
sudo usermod -aG docker $(whoami)
newgrp docker  # Or log out/in
```

**Kali tools not installed:**
```bash
# Check installation progress
docker-compose logs kali-workstation

# If stuck, restart Kali container
docker-compose restart kali-workstation
```

**Port conflicts:**
```bash
sudo netstat -tulpn | grep -E '8080|8081|5601'
```

## Learning Path

1. Start with DVWA (easiest)
2. Try WebGoat (guided lessons)
3. Challenge yourself with Juice Shop
4. Analyze honeypot logs in `honeypot/`
5. Use Kali tools from workstation
6. Check monitoring in Kibana

## Requirements

- Docker Engine 20.10+
- Docker Compose 2.0+
- 8GB RAM minimum
- 20GB disk space

## Legal

MIT licensed. Educational and authorized testing only. Don't attack systems without permission - you will get caught. Practice responsible disclosure.

See [SECURITY.md](SECURITY.md) for full policy.

## Contributing

Pull requests welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## Credits

Built with: DVWA, OWASP WebGoat, Juice Shop, Kali Linux, Cowrie, Elastic Stack.

**AI Integration**: Professional Grok-Code integration for security analysis and education.

If this helps you learn, star it and share it.

---

**Use this to get better at security, not to be a jerk.**
