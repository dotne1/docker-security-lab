#!/bin/bash
# Comprehensive verification script for security lab

echo "🔍 Security Lab Installation Verification"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASSED=0
FAILED=0

# Function to check something
check() {
    local name="$1"
    local command="$2"
    
    echo -n "Checking $name... "
    if eval "$command" &> /dev/null; then
        echo -e "${GREEN}✓ PASS${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        ((FAILED++))
        return 1
    fi
}

# File Structure Checks
echo "📁 File Structure"
echo "-----------------"
check "docker-compose.yml exists" "test -f docker-compose.yml"
# Grok-Code integration planned for future
check "scripts directory" "test -d scripts"
check "setup.sh is executable" "test -x scripts/setup.sh"
check "README.md exists" "test -f README.md"
check ".gitignore exists" "test -f .gitignore"
echo ""

# Python Syntax Checks
echo "🐍 Python Syntax"
echo "----------------"
# Grok-Code integration planned for future
echo ""

# Bash Syntax Checks
echo "💻 Bash Script Syntax"
echo "--------------------"
check "setup.sh syntax" "bash -n scripts/setup.sh"
# Grok-Code integration planned for future
check "status.sh syntax" "bash -n scripts/status.sh"
echo ""

# Docker Checks
echo "🐳 Docker Configuration"
echo "----------------------"
check "Docker is installed" "command -v docker"
check "Docker is running" "docker info"
check "User in docker group" "groups | grep -q docker"
check "docker-compose/docker compose available" "command -v docker-compose || docker compose version"
echo ""

# Directory Structure
echo "📂 Required Directories"
echo "----------------------"
check "kali directory" "test -d kali"
check "honeypot directory" "test -d honeypot"
check "monitoring directory" "test -d monitoring"
check "vulnerable-apps directory" "test -d vulnerable-apps"
check "networks directory" "test -d networks"
echo ""

# Documentation
echo "📚 Documentation"
echo "----------------"
check "Main README" "test -f README.md"
check "QUICKSTART guide" "test -f QUICKSTART.md"
check "START_HERE guide" "test -f START_HERE.md"
check "PROJECT_OVERVIEW" "test -f PROJECT_OVERVIEW.md"
# Grok-Code integration planned for future
check "Kali README" "test -f kali/README.md"
check "CODE_REVIEW" "test -f CODE_REVIEW.md"
echo ""

# Check if containers are running (if Docker is available)
if command -v docker &> /dev/null && docker info &> /dev/null; then
    echo "🔄 Docker Services (if started)"
    echo "------------------------------"
    
    if docker ps | grep -q kali-workstation; then
        check "Kali container running" "docker ps | grep -q kali-workstation"
        check "DVWA container running" "docker ps | grep -q dvwa"
        check "WebGoat container running" "docker ps | grep -q webgoat"
        check "Juice Shop container running" "docker ps | grep -q juiceshop"
        # Grok-Code integration planned for future
        check "Elasticsearch running" "docker ps | grep -q elasticsearch"
        check "Kibana running" "docker ps | grep -q kibana"
        
        echo ""
        echo "🌐 Service Accessibility"
        echo "-----------------------"
        check "DVWA accessible" "curl -s -o /dev/null -w '%{http_code}' http://localhost:8080 | grep -q 200"
        check "WebGoat accessible" "curl -s -o /dev/null -w '%{http_code}' http://localhost:8081 | grep -q 200"
        check "Juice Shop accessible" "curl -s -o /dev/null -w '%{http_code}' http://localhost:8082 | grep -q 200"
        # Grok-Code integration planned for future
        check "Kibana accessible" "curl -s -o /dev/null -w '%{http_code}' http://localhost:5601 | grep -q 200"
    else
        echo -e "${YELLOW}ℹ Containers not running (start with: docker-compose up -d)${NC}"
    fi
fi

# Summary
echo ""
echo "=========================================="
echo "Summary"
echo "=========================================="
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All checks passed! Your security lab is ready!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. If not started: docker-compose up -d"
    echo "2. Wait 2-3 minutes for services to initialize"
    echo "3. Run: ./scripts/status.sh"
    echo "4. Access DVWA: http://localhost:8080"
    echo ""
    exit 0
else
    echo -e "${RED}⚠️  Some checks failed. Review the output above.${NC}"
    echo ""
    echo "Common fixes:"
    echo "- Docker not installed: Run ./scripts/setup.sh"
    echo "- User not in docker group: Log out and back in"
    echo "- Services not running: Run docker-compose up -d"
    echo ""
    exit 1
fi

