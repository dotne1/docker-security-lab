# Grok-Code Integration

Professional integration of xAI's Grok-Code models into the security lab for AI-powered security assistance.

## 🚀 Features

- **Vulnerability Analysis**: Analyze code for security issues
- **Security Education**: Explain security concepts clearly
- **Educational Exploits**: Safe exploit techniques for lab environments
- **Payload Generation**: Educational payloads for testing
- **OpenAI-Compatible API**: Standard chat completions endpoint

## 📋 Setup

### 1. Get API Key

1. Visit [https://x.ai/api](https://x.ai/api)
2. Sign up for an account
3. Generate an API key
4. Add to your `.env` file:

```bash
GROK_API_KEY=your_grok_api_key_here
```

### 2. Start Service

```bash
# From security-lab root directory
docker-compose up -d grok-code-api
```

### 3. Test Connection

```bash
curl http://localhost:8180/health
```

## 🔧 API Endpoints

### Health Check
```bash
GET /health
```

### List Models
```bash
GET /v1/models
```

### Chat Completions (OpenAI Compatible)
```bash
POST /v1/chat/completions
Content-Type: application/json

{
  "messages": [
    {"role": "user", "content": "Explain SQL injection"}
  ],
  "model": "grok-code-fast-1",
  "temperature": 0.7,
  "max_tokens": 2000
}
```

### Vulnerability Analysis
```bash
POST /v1/analyze
Content-Type: application/json

{
  "code": "import os; os.system(input('Command: '))",
  "language": "python"
}
```

### Explain Security Concept
```bash
POST /v1/explain
Content-Type: application/json

{
  "concept": "SQL injection"
}
```

### Educational Exploit Suggestions
```bash
POST /v1/exploit
Content-Type: application/json

{
  "vulnerability": "SQL injection",
  "context": "DVWA lab environment"
}
```

### Generate Educational Payloads
```bash
POST /v1/payload
Content-Type: application/json

{
  "vulnerability_type": "SQL injection",
  "target_info": "MySQL database"
}
```

## 🤖 Available Models

- **grok-code-fast-1**: Fast coding model (recommended for code analysis)
- **grok-4-latest**: Latest Grok-4 model (general purpose)
- **grok-3-latest**: Latest Grok-3 model (general purpose)
- **grok-3-fast**: Fast Grok-3 model (quick responses)

## 💡 Usage Examples

### Python Client
```python
import requests

# Analyze vulnerable code
response = requests.post('http://localhost:8180/v1/analyze', json={
    'code': 'user_input = input("Enter: "); eval(user_input)',
    'language': 'python'
})
print(response.json()['analysis'])

# Explain security concept
response = requests.post('http://localhost:8180/v1/explain', json={
    'concept': 'Cross-site scripting (XSS)'
})
print(response.json()['explanation'])
```

### Curl Examples
```bash
# Test basic functionality
curl -X POST http://localhost:8180/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Hello!"}],
    "model": "grok-code-fast-1"
  }'

# Analyze code
curl -X POST http://localhost:8180/v1/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "code": "SELECT * FROM users WHERE id = " + user_id",
    "language": "sql"
  }'
```

## 🔒 Security Considerations

- **Educational Use Only**: All features designed for controlled lab environments
- **No Sensitive Data**: Never send real credentials or sensitive information
- **Rate Limiting**: Built-in rate limiting to prevent abuse
- **Audit Logging**: All interactions logged for security monitoring
- **Network Isolation**: Service runs in isolated Docker network

## 🛠️ Development

### Local Development
```bash
# Install dependencies
pip install -r requirements.txt

# Set environment variable
export GROK_API_KEY=your_key_here

# Run locally
python app.py
```

### Testing
```bash
# Test client directly
python client.py

# Test API endpoints
curl http://localhost:8180/health
```

## 📊 Monitoring

- **Health Checks**: Built-in health monitoring
- **Logging**: Comprehensive request/response logging
- **Metrics**: Track API usage and performance
- **Error Handling**: Graceful error responses

## 🚨 Troubleshooting

### Common Issues

1. **API Key Invalid**
   - Verify key at [https://x.ai/api](https://x.ai/api)
   - Check `.env` file configuration

2. **Service Won't Start**
   - Check Docker logs: `docker-compose logs grok-code-api`
   - Verify API key is set correctly

3. **Rate Limiting**
   - Reduce request frequency
   - Check API usage limits

### Debug Mode
```bash
# Enable debug logging
export FLASK_DEBUG=1
python app.py
```

## 📚 Resources

- [xAI API Documentation](https://x.ai/api)
- [Grok CLI Tool](https://github.com/superagent-ai/grok-cli)
- [OpenAI API Format](https://platform.openai.com/docs/api-reference)

## ⚖️ Legal Notice

This integration is designed for:
- Educational purposes only
- Controlled lab environments
- Authorized security testing
- Learning ethical hacking techniques

**Never use for malicious purposes or unauthorized testing.**
