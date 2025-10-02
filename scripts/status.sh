#!/bin/bash
# Check status of all security lab services

echo "🔐 Security Lab Status"
echo "====================="
echo ""

# Check if docker-compose is running
if ! docker-compose ps &> /dev/null; then
    echo "❌ Docker Compose not running or not in security-lab directory"
    exit 1
fi

# Display service status
echo "Service Status:"
echo "---------------"
docker-compose ps

echo ""
echo "Resource Usage:"
echo "---------------"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" $(docker-compose ps -q)

echo ""
echo "Access URLs:"
echo "------------"
echo "DVWA:          http://localhost:8080"
echo "WebGoat:       http://localhost:8081"
echo "Juice Shop:    http://localhost:8082"
echo "Kibana:        http://localhost:5601"
echo "Future:        Grok-Code integration planned"
echo "SSH Honeypot:  localhost:2222"
echo "Web Honeypot:  http://localhost:8888"

echo ""
echo "Quick Commands:"
echo "---------------"
echo "Access Kali:   docker exec -it kali-workstation /bin/bash"
echo "View logs:     docker-compose logs -f [service-name]"
echo "Restart:       docker-compose restart [service-name]"
echo "Stop all:      docker-compose down"
echo ""

