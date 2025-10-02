# Security Policy & Disclaimer

## ⚠️ IMPORTANT SECURITY WARNINGS

### THIS IS AN INTENTIONALLY VULNERABLE ENVIRONMENT

This repository contains **intentionally vulnerable applications** and security tools designed **exclusively** for:
- Security education and training
- Authorized penetration testing practice
- Security research in controlled environments
- Learning ethical hacking techniques

## 🚨 CRITICAL WARNINGS

### DO NOT:
- ❌ **NEVER expose these services to the public internet**
- ❌ **NEVER use in production environments**
- ❌ **NEVER store real or sensitive data**
- ❌ **NEVER use on networks you don't own or control**
- ❌ **NEVER attack systems without explicit authorization**
- ❌ **NEVER bypass the network isolation settings**

### DO:
-  **ONLY run in isolated, local environments**
-  **ONLY use for authorized security testing**
-  **ONLY test on systems you own or have written permission to test**
-  **Keep the lab isolated from production networks**
-  **Follow all applicable laws and regulations**
-  **Practice responsible disclosure**

## 🔒 Security Best Practices

### Network Isolation

The `vulnerable-network` in docker-compose.yml is configured as **internal only**:
```yaml
vulnerable-network:
  driver: bridge
  internal: true  # NO INTERNET ACCESS
```

**DO NOT remove this setting.** It prevents vulnerable applications from accessing or being accessed from the internet.

### Firewall Configuration

Add these firewall rules to ensure the lab is not accessible from other networks:

```bash
# Block external access to lab services (adjust interface as needed)
sudo ufw deny from any to any port 8080,8081,8082,5601,8180,2222,8888

# Only allow localhost
sudo ufw allow from 127.0.0.1 to any port 8080,8081,8082,5601,8180,2222,8888
```

### Monitoring

- Regularly review logs in `honeypot/` directories
- Monitor for unexpected network activity
- Check Docker logs for anomalies
- Review Kibana dashboards for suspicious patterns

##  Educational Use Only

This lab is designed for **educational purposes** under the following principles:

### Ethical Hacking Code of Conduct

1. **Authorization**: Only test systems you own or have explicit written permission to test
2. **Legality**: Comply with all local, state, and federal laws
3. **Responsibility**: Use knowledge to improve security, not cause harm
4. **Privacy**: Respect user privacy and data protection
5. **Disclosure**: Practice responsible vulnerability disclosure
6. **Documentation**: Keep detailed notes of your activities for learning

### Legal Disclaimer

By using this software, you agree that:

- You will use it solely for legal, authorized security testing and education
- You understand that unauthorized access to computer systems is illegal
- You will not use skills learned here for malicious purposes
- You accept full responsibility for your actions
- The authors/contributors are not liable for any misuse

## 🛡️ Vulnerable Components

This lab intentionally includes vulnerable software:

- **DVWA** (Damn Vulnerable Web Application) - Contains SQL injection, XSS, and other vulnerabilities
- **WebGoat** - Educational platform with intentional security flaws
- **OWASP Juice Shop** - Modern vulnerable web application
- **Honeypots** - Decoy services that log all connection attempts
- **Old/vulnerable libraries** - For educational demonstration

**These are NOT production-ready applications.** Do not use any code or practices from these vulnerable apps in real projects.

##  Protecting Your Lab

### Environment Variables

Never commit `.env` files containing credentials:
```bash
# .gitignore already includes:
.env
*.key
*.pem
*.crt
```

### Container Isolation

All containers run with resource limits:
- Memory limits prevent resource exhaustion
- CPU limits prevent runaway processes
- Non-root users where possible
- Minimal necessary capabilities

### Network Segmentation

Three isolated networks:
- `pentest-network`: Tools and testing infrastructure
- `vulnerable-network`: **ISOLATED** - no internet access
- `monitoring-network`: Logging and analysis

## 📋 Security Checklist

Before using this lab, verify:

- [ ] Lab is running on an isolated machine or VM
- [ ] No port forwarding from router to lab services
- [ ] Firewall rules are in place
- [ ] Not running on a shared network
- [ ] `.env` file is not committed to git
- [ ] All services are bound to localhost only (or internal Docker networks)
- [ ] You have authorization to perform security testing
- [ ] You understand the legal implications

## 🚨 Incident Response

If you discover:

### Unexpected Network Activity
1. Immediately stop all containers: `docker-compose down`
2. Review logs: `docker-compose logs`
3. Check honeypot logs for intrusion attempts
4. Investigate source of activity

### Accidental Exposure
1. **Immediately** shut down exposed services
2. Review firewall and router settings
3. Check access logs for unauthorized access
4. Change all credentials
5. Rebuild containers from clean images

### System Compromise
1. Disconnect from network immediately
2. Preserve logs for investigation
3. Do not restart services
4. Review all system logs
5. Consider full system rebuild

##  Reporting Issues

### Security Issues in the Lab Setup
If you find a security issue in the lab **configuration** (not the intentionally vulnerable apps):
- Open a GitHub issue with details
- Do not disclose critical issues publicly until patched
- Use responsible disclosure practices

### Issues with Intentional Vulnerabilities
The vulnerable applications (DVWA, WebGoat, Juice Shop) are **supposed** to be vulnerable. Do not report their vulnerabilities as issues.

##  Compliance

### For Educational Institutions
- Ensure lab usage complies with institution policies
- Obtain necessary approvals from IT security
- Use isolated networks or VLANs
- Monitor student usage appropriately
- Include ethics training

### For Organizations
- Get authorization from security team
- Use isolated development/training networks
- Document security controls
- Implement monitoring and logging
- Regular security audits

### For Individuals
- Use at home on personal equipment only
- Keep isolated from production systems
- Ensure your ISP's ToS allows security testing
- Don't violate any agreements or laws
- Practice responsible security research

##  Additional Resources

- [OWASP Code of Ethics](https://owasp.org/www-project-code-of-ethics/)
- [EC-Council Code of Ethics](https://www.eccouncil.org/code-of-ethics/)
- [(ISC)² Code of Ethics](https://www.isc2.org/Ethics)
- [SANS Security Ethics](https://www.sans.org/security-resources/ethics.php)

## ⚖️ Legal Information

### This Lab is Legal When:
- Used for authorized security testing
- Run in controlled, isolated environments
- Used for education and training
- Compliant with all applicable laws

### This Lab is Illegal When:
- Used to attack systems without authorization
- Used to access others' data without permission
- Used to cause damage or disruption
- Used in violation of computer fraud laws

**Know your local laws.** Computer fraud laws vary by jurisdiction.

---

##  Version & Updates

This security policy applies to all versions of this lab. As the threat landscape evolves, security practices should be reviewed and updated regularly.

**Last Updated**: October 2025

---

**Remember**: With great power comes great responsibility. Use this knowledge to make the internet more secure, not less. 🛡️

