# Contributing to Security Lab

Contributions welcome.

## Code of Conduct

This project is designed for **educational and ethical security research only**. By contributing, you agree to:

- Use and promote ethical hacking practices
- Never contribute code that could be used maliciously
- Respect privacy and security
- Follow responsible disclosure practices
- Comply with all applicable laws

## How Can I Contribute?

### Reporting Bugs

**Important**: Only report bugs in the **lab configuration**, not the intentional vulnerabilities in DVWA/WebGoat/Juice Shop (those are supposed to be vulnerable!).

Before submitting:
- Check if the issue already exists
- Verify it's not an intentional vulnerability
- Test on a clean installation

Include in your report:
- Docker version
- Operating system
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs

### Suggesting Enhancements

We welcome suggestions for:
- Additional vulnerable applications
- New security tools
- Better documentation
- Improved network configurations
- Enhanced monitoring capabilities
- Educational resources

Open an issue with:
- Clear description of enhancement
- Use case or benefit
- Potential implementation approach

### Documentation Improvements

Documentation is crucial! You can help by:
- Fixing typos or unclear explanations
- Adding examples
- Translating to other languages
- Creating video tutorials
- Writing blog posts about the lab

### Code Contributions

#### Areas for Contribution

1. **Additional Vulnerable Apps**
   - Add new intentionally vulnerable applications
   - Include clear documentation
   - Ensure proper isolation

2. **Security Tools**
   - Integration with additional pentesting tools
   - Automation scripts
   - Analysis tools

3. **Monitoring Enhancements**
   - Better Kibana dashboards
   - Automated alerting
   - Log analysis scripts

4. **Educational Content**
   - Step-by-step tutorials
   - Challenge scenarios
   - Learning paths

#### Pull Request Process

1. **Fork the Repository**
   ```bash
   git clone https://github.com/yourusername/security-lab.git
   cd security-lab
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Follow existing code style
   - Add comments where needed
   - Update documentation
   - Test thoroughly

4. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add: Brief description of changes"
   ```

   Commit message format:
   - `Add:` for new features
   - `Fix:` for bug fixes
   - `Update:` for updates to existing features
   - `Docs:` for documentation only changes

5. **Push and Create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Pull Request Guidelines**
   - Describe what and why
   - Reference any related issues
   - Include testing steps
   - Update relevant documentation

## Development Guidelines

### Docker Compose Services

When adding new services:

```yaml
new-service:
  image: service/image
  container_name: descriptive-name
  networks:
    - appropriate-network  # Choose correct isolation level
  ports:
    - "host:container"    # Document why port is exposed
  mem_limit: 512m         # Always set resource limits
  cpus: 1
  environment:
    - VAR=value
```

### Security Requirements

All contributions must:

-  Not expose vulnerable apps to internet
-  Use environment variables for secrets
-  Include resource limits
-  Have appropriate network isolation
-  Include security warnings in docs
-  Follow principle of least privilege

### Documentation Standards

- Use clear, concise language
- Include examples where helpful
- Add security warnings where appropriate
- Keep beginner-friendly tone
- Provide troubleshooting tips

### Testing

Before submitting:

```bash
# Test Docker Compose syntax
docker-compose config --quiet

# Test Python syntax
python3 -m py_compile your-script.py

# Test Bash syntax
bash -n your-script.sh

# Test the full stack
docker-compose up -d
# Wait and test services
docker-compose down
```

## Project Structure

```
security-lab/
├── docker-compose.yml      # Main orchestration
├── future/                 # Planned Grok-Code integration
├── kali/                  # Kali workspace
├── vulnerable-apps/       # Custom vulnerable apps
├── honeypot/             # Honeypot configs
├── monitoring/           # ELK stack data
├── networks/             # Network documentation
├── scripts/              # Helper scripts
└── docs/                 # Additional documentation
```

## Style Guide

### Shell Scripts
- Use `#!/bin/bash` shebang
- Include error handling (`set -e`)
- Add comments for complex logic
- Use meaningful variable names
- Include usage examples

### Python
- Follow PEP 8
- Use type hints where appropriate
- Include docstrings
- Handle errors gracefully
- Add logging for debugging

### Documentation (Markdown)
- Use proper heading hierarchy
- Include code blocks with syntax highlighting
- Add emojis for visual clarity
- Use tables for structured data
- Include both examples and explanations

## Security Considerations for Contributors

### When Adding Vulnerable Apps

1. **Clearly mark as vulnerable**
   - Add WARNING to documentation
   - Explain what vulnerabilities exist
   - Document educational purpose

2. **Ensure isolation**
   - Use `vulnerable-network` (internal only)
   - No internet access
   - Appropriate resource limits

3. **Document safely**
   - Explain how to exploit safely
   - Include remediation examples
   - Provide secure coding alternatives

### When Adding Tools

1. **Verify legitimacy**
   - Use official Docker images when possible
   - Check for known vulnerabilities
   - Review source code if needed

2. **Document usage**
   - Provide clear examples
   - Explain legal use cases only
   - Include ethical considerations

## Review Process

Pull requests will be reviewed for:

1. **Functionality**: Does it work as described?
2. **Security**: Does it maintain isolation and safety?
3. **Documentation**: Is it well documented?
4. **Code Quality**: Is it clean and maintainable?
5. **Ethics**: Does it promote ethical hacking?

## Questions?

- Open an issue for questions
- Check existing documentation
- Review similar contributions

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Credited in release notes
- Appreciated in the community! 

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for helping make security education more accessible!** 🛡️

