# Vulnerable Applications

This directory is for custom vulnerable applications you want to add to your security lab.

## Built-in Vulnerable Apps

The lab comes with three pre-configured vulnerable applications:

### 1. DVWA (Damn Vulnerable Web Application)
- **URL**: http://localhost:8080
- **Default Credentials**: admin / password
- **Focus**: Classic web vulnerabilities (SQL injection, XSS, CSRF, etc.)
- **Difficulty Levels**: Low, Medium, High, Impossible

**Getting Started**:
1. Access http://localhost:8080
2. Login with admin/password
3. Click "Create / Reset Database"
4. Start testing!

### 2. WebGoat
- **URL**: http://localhost:8081
- **Credentials**: Create your own account
- **Focus**: OWASP Top 10 with interactive lessons
- **Type**: Educational platform

**Getting Started**:
1. Access http://localhost:8081
2. Register a new account
3. Follow the guided lessons
4. Learn by doing!

### 3. OWASP Juice Shop
- **URL**: http://localhost:8082
- **Focus**: Modern web application vulnerabilities
- **Features**: RESTful API, real-world scenarios
- **Challenges**: 100+ security challenges

**Getting Started**:
1. Access http://localhost:8082
2. Browse the "store"
3. Look for security issues!
4. Check the scoreboard

## Adding Custom Vulnerable Apps

You can add your own vulnerable applications to this directory.

### Example: Adding a Custom Node.js App

1. Create your app directory:
```bash
mkdir -p docker-security-lab/vulnerable-apps/my-app
cd docker-security-lab/vulnerable-apps/my-app
```

2. Create a Dockerfile:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

3. Add to docker-compose.yml:
```yaml
  my-vulnerable-app:
    build: ./vulnerable-apps/my-app
    container_name: my-app
    networks:
      - vulnerable-network
      - monitoring-network
    ports:
      - "3001:3000"
    mem_limit: 512m
    cpus: 1
```

### Example: Adding a Vulnerable Python API

```yaml
  vulnerable-api:
    build: ./vulnerable-apps/python-api
    container_name: vulnerable-api
    networks:
      - vulnerable-network
    ports:
      - "5000:5000"
    environment:
      - FLASK_ENV=development
      - DEBUG=1
```

## Pre-built Vulnerable Docker Images

You can also use pre-built vulnerable containers:

```yaml
  # Vulnerable WordPress
  wordpress:
    image: wordpress:5.8  # Old version with known vulnerabilities
    networks:
      - vulnerable-network
    ports:
      - "8083:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: password

  # Vulnerable Java App (Spring Boot)
  vulnerable-spring:
    image: cyberxsecurity/dvja  # Damn Vulnerable Java Application
    networks:
      - vulnerable-network
    ports:
      - "8084:8080"

  # Vulnerable Node.js
  nodegoat:
    image: owasp/nodegoat
    networks:
      - vulnerable-network
    ports:
      - "8085:4000"
```

## Security Testing Ideas

### SQL Injection Testing
- DVWA SQL Injection (Low difficulty)
- WebGoat SQL Injection lessons
- Custom login forms

### Cross-Site Scripting (XSS)
- DVWA XSS (Reflected, Stored, DOM)
- Juice Shop comment sections
- Search functionality

### Authentication Bypass
- Juice Shop login page
- WebGoat authentication lessons
- Custom auth mechanisms

### API Security
- Juice Shop REST API
- Custom API endpoints
- JWT token manipulation

### File Upload Vulnerabilities
- DVWA file upload
- Custom upload forms
- WebGoat file upload lessons

## Example Testing Workflow

1. **Reconnaissance**:
```bash
docker exec kali-workstation nmap -sV -p- dvwa
docker exec kali-workstation nikto -h http://dvwa
```

2. **Vulnerability Scanning**:
```bash
docker exec kali-workstation wpscan --url http://wordpress
docker exec kali-workstation sqlmap -u "http://dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#"
```

3. **Manual Testing**:
- Use Burp Suite for intercepting requests
- Try manual SQL injection payloads
- Test for XSS in input fields

4. **Exploitation**:
- Use Metasploit for known exploits
- Develop custom exploits
- Document findings

## Best Practices

1. **Keep Apps Isolated**: Always use the `vulnerable-network` for vulnerable apps
2. **No Internet Access**: Vulnerable apps should not have internet access
3. **Regular Resets**: Reset apps frequently to clean state
4. **Document Findings**: Keep notes on vulnerabilities found
5. **Ethical Testing**: Only test in your lab, never in production

## Resources

- [DVWA Documentation](https://github.com/digininja/DVWA)
- [WebGoat Documentation](https://owasp.org/www-project-webgoat/)
- [Juice Shop](https://owasp.org/www-project-juice-shop/)
- [VulnHub](https://www.vulnhub.com/) - Download vulnerable VMs
- [OWASP Vulnerable Web Applications Directory](https://owasp.org/www-project-vulnerable-web-applications-directory/)

## Contributing Your Own

If you create a good vulnerable application for learning:
1. Document the vulnerabilities
2. Create a README
3. Share with the community!

Happy (ethical) hacking! 🔐

