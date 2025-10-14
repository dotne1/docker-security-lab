# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-10-14

### Security
- **Critical**: Fixed network isolation vulnerability where vulnerable apps could access internet
- Added automated network security enforcement container with iptables
- Vulnerable apps now properly isolated while maintaining port publishing

### Fixed
- WebGoat false "unhealthy" status (disabled broken health check)
- setup.sh creating outdated .env template

### Added
- network-security service: Automated iptables enforcement (zero config)
- Comprehensive testing documentation (BUGS_AND_FIXES.md, TESTING_SUMMARY.md)

### Changed
- setup.sh now copies from env.example for .env template

## [1.0.0] - 2025-10-01

### Added
- Complete Docker-based security lab environment
- Kali Linux workstation with pre-installed tools
- Vulnerable applications (DVWA, WebGoat, Juice Shop)
- Planned Grok-Code API integration for AI-powered security assistance
- ELK Stack (Elasticsearch + Kibana) for monitoring
- SSH and Web honeypots for attack analysis
- Three isolated Docker networks (pentest, vulnerable, monitoring)
- Comprehensive documentation (9 READMEs)
- Helper scripts for setup, status checking, and verification
- Security policy and ethical use guidelines
- Contributing guidelines
- MIT License

### Security
- Network isolation for vulnerable applications
- Resource limits on all containers
- Non-root users in custom containers
- Environment variable-based secrets management
- Comprehensive .gitignore for sensitive data
- Security warnings throughout documentation

### Documentation
- README.md - Main documentation
- QUICKSTART.md - 5-minute setup guide
- START_HERE.md - Getting started guide
- PROJECT_OVERVIEW.md - Project overview
- HOW_TO_USE.md - Detailed usage instructions
- SECURITY.md - Security policy and warnings
- CONTRIBUTING.md - Contribution guidelines
- LICENSE - MIT license with disclaimer
- Component-specific READMEs (Kali, Grok, Honeypot, etc.)

### Scripts
- setup.sh - Automated installation and setup
- verify-installation.sh - Installation verification
- status.sh - Service status checker
- Future: Grok-Code integration planned
- scan-vulnerabilities.sh - Vulnerability scanning example

## [Unreleased]

### Planned
- Additional vulnerable applications
- More automation scripts
- Advanced Kibana dashboards
- Integration with additional security tools
- Video tutorials
- Challenge scenarios

---

## Version History

### Version Naming Convention
- Major version (X.0.0): Significant architectural changes
- Minor version (0.X.0): New features or services
- Patch version (0.0.X): Bug fixes and documentation updates

### Support
- Latest version: Fully supported
- Previous major version: Security updates only
- Older versions: No longer supported

---

For upgrade instructions and migration guides, see the documentation for each release.

