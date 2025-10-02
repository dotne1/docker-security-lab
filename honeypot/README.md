# Honeypots

Honeypots are decoy systems designed to attract and log malicious activity.

## Overview

This lab includes two honeypots:
1. **SSH Honeypot** (Cowrie) - Port 2222
2. **Web Honeypot** (Nginx) - Port 8888

## SSH Honeypot (Cowrie)

### What is Cowrie?

Cowrie is a medium-interaction SSH and Telnet honeypot that:
- Logs brute force attacks
- Records shell interaction
- Captures malware downloads
- Logs commands executed by attackers

### Access Logs

Location: `./ssh-logs/`

```bash
# View real-time logs
tail -f honeypot/ssh-logs/cowrie.log

# View JSON formatted logs
tail -f honeypot/ssh-logs/cowrie.json

# Search for specific usernames
grep "username" honeypot/ssh-logs/cowrie.log

# Count login attempts
grep -c "login attempt" honeypot/ssh-logs/cowrie.log
```

### Testing the Honeypot

```bash
# Try to connect (will fail but will be logged)
ssh -p 2222 root@localhost

# Try common passwords (for testing only!)
sshpass -p 'admin' ssh -p 2222 admin@localhost
sshpass -p 'password' ssh -p 2222 root@localhost
```

### Log Format

Cowrie logs include:
- Source IP address
- Username attempted
- Password attempted
- Commands executed
- Files downloaded
- Session duration

Example log entry:
```json
{
  "eventid": "cowrie.login.success",
  "username": "root",
  "password": "password123",
  "message": "login attempt [root/password123] succeeded",
  "sensor": "ssh-honeypot",
  "src_ip": "172.20.0.5"
}
```

### Analysis

```bash
# Most common usernames
cat ssh-logs/cowrie.json | grep username | sort | uniq -c | sort -rn

# Most common passwords
cat ssh-logs/cowrie.json | grep password | sort | uniq -c | sort -rn

# Unique source IPs
cat ssh-logs/cowrie.json | grep src_ip | cut -d'"' -f4 | sort -u

# Commands executed by attackers
grep "CMD:" ssh-logs/cowrie.log
```

## Web Honeypot

### What is it?

A simple Nginx-based web honeypot that:
- Presents a fake admin login page
- Logs all access attempts
- Captures malicious requests
- Records potential exploits

### Access Logs

Location: `./web-logs/`

```bash
# View access logs
tail -f honeypot/web-logs/access.log

# View error logs
tail -f honeypot/web-logs/error.log

# Find suspicious requests
grep -E "(\.\.\/|union|select|script|eval)" honeypot/web-logs/access.log
```

### Testing the Honeypot

```bash
# Access the fake login page
curl http://localhost:8888

# Try common exploits (for testing only!)
curl "http://localhost:8888/admin.php?id=1' OR '1'='1"
curl "http://localhost:8888/<script>alert('xss')</script>"
curl "http://localhost:8888/../../../etc/passwd"
```

### Log Analysis

```bash
# Most requested URLs
awk '{print $7}' web-logs/access.log | sort | uniq -c | sort -rn | head -20

# User agents (identify bots/scanners)
awk -F'"' '{print $6}' web-logs/access.log | sort | uniq -c | sort -rn

# HTTP status codes
awk '{print $9}' web-logs/access.log | sort | uniq -c | sort -rn

# Potential SQL injection attempts
grep -i "union\|select\|drop\|insert" web-logs/access.log

# Potential XSS attempts
grep -i "script\|javascript\|onerror\|onload" web-logs/access.log

# Directory traversal attempts
grep "\.\." web-logs/access.log
```

## Advanced Honeypot Configuration

### Customize SSH Honeypot

To add custom responses or behavior:

1. Create custom configuration:
```yaml
# honeypot/cowrie.cfg
[honeypot]
hostname = vulnerable-server
arch = linux-x64-lsb

[output_jsonlog]
logfile = var/log/cowrie/cowrie.json
```

2. Add to docker-compose.yml:
```yaml
ssh-honeypot:
  volumes:
    - ./honeypot/cowrie.cfg:/cowrie/etc/cowrie.cfg
```

### Customize Web Honeypot

Modify `web-content/index.html` to create different decoys:

```bash
# Create fake WordPress admin
cp web-content/index.html web-content/wp-admin.html

# Create fake phpMyAdmin
cp web-content/index.html web-content/phpMyAdmin.html
```

## Threat Intelligence

### Identify Attack Patterns

```bash
# Common attack vectors in 24 hours
cat web-logs/access.log | grep $(date +%d/%b/%Y) | \
  awk '{print $7}' | sort | uniq -c | sort -rn | head -10

# Identify scanning activity
# (Multiple requests from same IP in short time)
awk '{print $1}' web-logs/access.log | sort | uniq -c | sort -rn | head -20
```

### Blacklist Generation

```bash
# Generate list of malicious IPs (10+ failed attempts)
grep "failed" ssh-logs/cowrie.log | \
  grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | \
  sort | uniq -c | sort -rn | awk '$1 >= 10 {print $2}' > blacklist.txt
```

### Integration with Fail2Ban

You could integrate honeypot logs with Fail2Ban to automatically block attackers.

## Visualization

### Create Dashboards in Kibana

1. **Attack Heatmap**: Visualize attacks over time
2. **Geographic Map**: Show origin of attacks (if IPs are geolocated)
3. **Top Attackers**: Table of most active IPs
4. **Credential Attempts**: Bar chart of usernames/passwords tried

### Example: Parse Logs into Elasticsearch

```bash
# Simple script to send logs to Elasticsearch
cat ssh-logs/cowrie.json | while read line; do
  curl -X POST "http://localhost:9200/honeypot-ssh/_doc" \
    -H 'Content-Type: application/json' \
    -d "$line"
done
```

## Security Considerations

⚠️ **Important**:

1. **Isolation**: Honeypots should be isolated from production systems
2. **No Sensitive Data**: Never put real credentials or data in honeypots
3. **Legal**: Ensure honeypots are legal in your jurisdiction
4. **Containment**: Honeypots should not be able to attack other systems
5. **Monitoring**: Always monitor honeypots for compromise

## Best Practices

1. **Regular Log Review**: Check logs daily for interesting activity
2. **Log Rotation**: Implement log rotation to prevent disk space issues
3. **Backup**: Backup logs before they're rotated
4. **Analysis**: Use logs to understand attacker tactics
5. **Sharing**: Consider sharing findings with security community

## Adding More Honeypots

### Example: FTP Honeypot

```yaml
ftp-honeypot:
  image: andrewmichaelsmith/honeypot-ftp
  container_name: ftp-honeypot
  networks:
    - pentest-network
  ports:
    - "2121:21"
  volumes:
    - ./honeypot/ftp-logs:/var/log
```

### Example: SMTP Honeypot

```yaml
smtp-honeypot:
  image: pbertera/smtp-honeypot
  container_name: smtp-honeypot
  networks:
    - pentest-network
  ports:
    - "2525:25"
  volumes:
    - ./honeypot/smtp-logs:/var/log
```

### Example: Database Honeypot

```yaml
mysql-honeypot:
  image: qeeqbox/honeypots
  container_name: mysql-honeypot
  networks:
    - pentest-network
  ports:
    - "3307:3306"
  environment:
    - HONEYPOT=mysql
```

## Real-World Use Cases

1. **Threat Intelligence**: Learn about new attack techniques
2. **Early Warning**: Detect scanning activity before real systems are hit
3. **Research**: Study attacker behavior and tools
4. **Training**: Demonstrate real attack scenarios
5. **Distraction**: Keep attackers busy away from real systems

## Resources

- [Cowrie Documentation](https://github.com/cowrie/cowrie)
- [Awesome Honeypots](https://github.com/paralax/awesome-honeypots)
- [SANS Honeypot Guide](https://www.sans.org/reading-room/whitepapers/detection/deploying-honeypots-33548)
- [Modern Honey Network](https://github.com/pwnlandia/mhn)

## Reporting

Create a daily report:

```bash
#!/bin/bash
# Daily honeypot report

DATE=$(date +%Y-%m-%d)
REPORT="honeypot-report-$DATE.txt"

echo "Honeypot Daily Report - $DATE" > $REPORT
echo "================================" >> $REPORT
echo "" >> $REPORT

echo "SSH Honeypot Statistics:" >> $REPORT
echo "Total login attempts: $(grep -c 'login attempt' ssh-logs/cowrie.log)" >> $REPORT
echo "Unique IPs: $(grep 'src_ip' ssh-logs/cowrie.json | cut -d'"' -f4 | sort -u | wc -l)" >> $REPORT
echo "" >> $REPORT

echo "Top 10 Usernames:" >> $REPORT
grep 'username' ssh-logs/cowrie.json | cut -d'"' -f4 | sort | uniq -c | sort -rn | head -10 >> $REPORT
echo "" >> $REPORT

echo "Web Honeypot Statistics:" >> $REPORT
echo "Total requests: $(wc -l < web-logs/access.log)" >> $REPORT
echo "Unique IPs: $(awk '{print $1}' web-logs/access.log | sort -u | wc -l)" >> $REPORT
echo "" >> $REPORT

cat $REPORT
```

Happy hunting! 🍯🐝

