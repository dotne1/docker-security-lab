# Monitoring and Logging

This directory contains data for the Elasticsearch and Kibana monitoring stack.

## Overview

The monitoring stack provides real-time visibility into:
- Container logs
- Network traffic
- Security events
- Honeypot activity
- Attack patterns

## Components

### Elasticsearch
- **Port**: 9200
- **Purpose**: Log storage and indexing
- **Data Location**: `./elasticsearch-data/`

### Kibana
- **Port**: 5601
- **Purpose**: Log visualization and dashboards
- **URL**: http://localhost:5601

## Getting Started

### 1. Access Kibana

Open http://localhost:5601 in your browser (wait 2-3 minutes after starting for it to be ready).

### 2. Create Index Pattern

1. Click "Discover" in the left menu
2. Click "Create index pattern"
3. Enter pattern: `filebeat-*` or `logstash-*`
4. Select `@timestamp` as the time field
5. Click "Create index pattern"

### 3. View Logs

- Go to "Discover" to see real-time logs
- Use the search bar to filter logs
- Click on log entries to expand details

## Monitoring Docker Containers

### View Container Logs Directly
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f dvwa

# Last 100 lines
docker-compose logs --tail=100 kali-workstation
```

### Container Stats
```bash
# Real-time stats
docker stats

# One-time snapshot
docker stats --no-stream
```

## Elasticsearch Queries

### Basic Search
```bash
# Search for errors
curl "http://localhost:9200/_search?q=error"

# Search in specific index
curl "http://localhost:9200/logs-*/_search?q=status:500"
```

### Advanced Queries
```bash
# JSON query
curl -X POST "http://localhost:9200/_search" \
  -H 'Content-Type: application/json' \
  -d '{
    "query": {
      "match": {
        "message": "authentication failed"
      }
    }
  }'
```

## Creating Dashboards

### Security Events Dashboard

1. Go to Kibana → Dashboard → Create Dashboard
2. Add visualizations:
   - **Failed Login Attempts**: Count of failed SSH attempts
   - **HTTP Error Codes**: Pie chart of 4xx/5xx errors
   - **Top Attack Sources**: Table of IP addresses
   - **Timeline**: Line graph of events over time

### Example Visualization: Failed Logins

1. Go to "Visualize" → Create Visualization
2. Select "Vertical Bar" chart
3. Choose your index pattern
4. Add:
   - Y-axis: Count
   - X-axis: Date Histogram on @timestamp
   - Filter: `message: "failed" OR status: "401"`

## Honeypot Monitoring

### SSH Honeypot Logs

Location: `./honeypot/ssh-logs/`

View logs:
```bash
# Real-time
tail -f honeypot/ssh-logs/cowrie.log

# Search for specific attacks
grep "password" honeypot/ssh-logs/cowrie.log

# Count login attempts
grep -c "login attempt" honeypot/ssh-logs/cowrie.log
```

### Web Honeypot Logs

Location: `./honeypot/web-logs/`

View logs:
```bash
# Access logs
tail -f honeypot/web-logs/access.log

# Error logs
tail -f honeypot/web-logs/error.log

# Find suspicious requests
grep -E "(\.\.\/|union|select|script)" honeypot/web-logs/access.log
```

## Alerting

### Example: Alert on SQL Injection Attempts

Create a Kibana alert:
1. Go to Stack Management → Rules and Connectors
2. Create rule
3. Select "Elasticsearch query"
4. Query: `message: "union" OR message: "select"`
5. Set threshold and action (e.g., email notification)

### Command-line Monitoring

```bash
# Watch for SQL injection attempts
watch -n 1 'docker logs dvwa 2>&1 | grep -i "select\|union\|drop"'

# Monitor authentication failures
watch -n 1 'docker logs ssh-honeypot 2>&1 | grep -c "failed"'
```

## Log Analysis Examples

### Find Most Attacked Endpoints
```bash
# From web honeypot
cat honeypot/web-logs/access.log | awk '{print $7}' | sort | uniq -c | sort -rn | head -20
```

### Identify Attack Patterns
```bash
# Look for common vulnerability scans
cat honeypot/web-logs/access.log | grep -E "phpMyAdmin|wp-admin|.env|.git"
```

### Geo-locate Attacks (if logs include IPs)
```bash
# Extract unique IPs
cat honeypot/ssh-logs/cowrie.log | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -u > ips.txt

# Use external tool to geolocate (example)
# for ip in $(cat ips.txt); do curl "ipapi.co/$ip/json/"; done
```

## Elasticsearch Maintenance

### Check Cluster Health
```bash
curl http://localhost:9200/_cluster/health?pretty
```

### List Indices
```bash
curl http://localhost:9200/_cat/indices?v
```

### Delete Old Indices (Free Space)
```bash
# Delete indices older than 30 days
curl -X DELETE "http://localhost:9200/logs-2024.01.*"
```

### Optimize Index
```bash
curl -X POST "http://localhost:9200/_forcemerge"
```

## Advanced Monitoring

### Add Filebeat for Enhanced Logging

Create `docker-compose.override.yml`:
```yaml
version: '3.8'

services:
  filebeat:
    image: docker.elastic.co/beats/filebeat:8.10.2
    container_name: filebeat
    user: root
    networks:
      - monitoring-network
    volumes:
      - ./monitoring/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    depends_on:
      - elasticsearch
```

Create `monitoring/filebeat.yml`:
```yaml
filebeat.inputs:
  - type: container
    paths:
      - '/var/lib/docker/containers/*/*.log'

processors:
  - add_docker_metadata:
      host: "unix:///var/run/docker.sock"

output.elasticsearch:
  hosts: ["elasticsearch:9200"]
  indices:
    - index: "filebeat-%{+yyyy.MM.dd}"
```

### Add Logstash for Log Processing

For more advanced log processing and filtering, add Logstash between services and Elasticsearch.

## Security Considerations

1. **No External Access**: Keep Elasticsearch/Kibana on internal networks only
2. **Authentication**: In production, enable security features
3. **Encryption**: Use HTTPS for Kibana in production
4. **Backup**: Regularly backup Elasticsearch data
5. **Retention**: Set up index lifecycle management to delete old logs

## Troubleshooting

### Elasticsearch won't start
```bash
# Check logs
docker logs elasticsearch

# Common issue: Not enough memory
# Edit docker-compose.yml to reduce ES_JAVA_OPTS or increase Docker memory
```

### Kibana shows "Elasticsearch not ready"
```bash
# Check Elasticsearch health
curl http://localhost:9200/_cluster/health

# Wait a few minutes - Elasticsearch takes time to start
```

### Disk space full
```bash
# Check disk usage
du -sh monitoring/elasticsearch-data/

# Delete old indices or increase disk space
```

### Can't see logs in Kibana
1. Verify index pattern is correct
2. Check time range (top-right in Kibana)
3. Ensure data is being sent to Elasticsearch:
   ```bash
   curl http://localhost:9200/_cat/indices?v
   ```

## Best Practices

1. **Regular Backups**: Backup `elasticsearch-data/` directory
2. **Index Rotation**: Use date-based indices (e.g., `logs-2024.10.01`)
3. **Retention Policy**: Delete logs older than X days
4. **Performance**: Monitor Elasticsearch resource usage
5. **Documentation**: Document your dashboards and queries

## Resources

- [Elasticsearch Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Kibana Documentation](https://www.elastic.co/guide/en/kibana/current/index.html)
- [Elastic Stack Security](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-minimal-setup.html)
- [Filebeat Documentation](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)

## Example Queries for Security Testing

```
# Find SQL injection attempts
message: "select" OR message: "union" OR message: "drop table"

# Find XSS attempts  
message: "<script>" OR message: "javascript:" OR message: "onerror="

# Find authentication failures
status: 401 OR message: "authentication failed" OR message: "invalid password"

# Find suspicious file access
message: "../" OR message: "passwd" OR message: ".env"

# Find potential RCE attempts
message: "system(" OR message: "exec(" OR message: "shell_exec"
```

Happy monitoring! 📊

