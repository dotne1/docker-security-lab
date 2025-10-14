#!/bin/bash
# Security Lab Setup Script

set -e

echo "🔐 Security Lab Setup Script"
echo "============================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker not found. Installing Docker...${NC}"
    sudo apt update
    sudo apt install -y docker.io docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Docker installed! Please log out and back in, then run this script again.${NC}"
    exit 0
fi

# Check if user is in docker group
if ! groups | grep -q docker; then
    echo -e "${YELLOW}Adding user to docker group...${NC}"
    sudo usermod -aG docker $USER
    echo -e "${GREEN}User added to docker group!${NC}"
    echo -e "${YELLOW}You need to log out and back in for changes to take effect.${NC}"
    echo -e "${YELLOW}Or run: newgrp docker${NC}"
    echo ""
    echo "After that, run this script again or proceed with:"
    echo "  docker-compose up -d"
    exit 0
fi

# Check for .env file
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file from template...${NC}"
    if [ -f env.example ]; then
        cp env.example .env
        echo -e "${GREEN}.env file created from env.example!${NC}"
        echo -e "${YELLOW}Please edit .env and add your Grok API key (optional)${NC}"
    else
        echo -e "${RED}Warning: env.example not found!${NC}"
    fi
    echo ""
fi

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p kali/workspace
mkdir -p kali/tools
mkdir -p kali/metasploit-db
mkdir -p monitoring/elasticsearch-data
mkdir -p honeypot/ssh-logs
mkdir -p honeypot/web-logs
mkdir -p honeypot/web-content

# Set permissions
echo "Setting permissions..."
chmod 777 monitoring/elasticsearch-data
chmod 755 honeypot/ssh-logs honeypot/web-logs

# Pull Docker images
echo -e "${GREEN}Pulling Docker images... (this may take a while)${NC}"
docker-compose pull

echo -e "${GREEN}Installing Kali tools and dependencies...${NC}"
echo "This includes: nmap, metasploit, sqlmap, nikto, dirb, hydra, john, netcat, curl, wget, git, nano, vim"
echo "Plus all required libraries: libblas3, liblapack3, libblas-dev, liblapack-dev"

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. (Optional) Edit .env and add your Grok API key for AI assistance"
echo "2. Run: docker-compose up -d"
echo "3. Wait 5-10 minutes for Kali tools to install (first time only)"
echo "4. Access services at:"
echo "   - DVWA: http://localhost:8080"
echo "   - WebGoat: http://localhost:8081"
echo "   - Juice Shop: http://localhost:8082"
echo "   - Kibana: http://localhost:5601"
echo "   - Grok-Code API: http://localhost:8180"
echo ""
echo "To access Kali Linux: docker exec -it kali-workstation /bin/bash"
echo ""
echo "Check status: ./scripts/status.sh"
echo ""

