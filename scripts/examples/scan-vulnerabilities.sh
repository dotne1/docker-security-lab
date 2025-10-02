#!/bin/bash
# Example: Scan vulnerable applications from Kali

echo "🔍 Scanning Vulnerable Applications"
echo "===================================="
echo ""

# Array of targets
targets=("dvwa" "webgoat" "juiceshop")

for target in "${targets[@]}"; do
    echo "Scanning $target..."
    echo "-------------------"
    
    # Nmap scan
    echo "Running Nmap scan..."
    docker exec kali-workstation nmap -sV -Pn $target
    
    echo ""
done

echo "✅ Scans complete!"
echo ""
echo "Next steps:"
echo "- Review scan results above"
echo "- Try Nikto: docker exec kali-workstation nikto -h http://dvwa"
echo "- Try SQLMap: docker exec kali-workstation sqlmap -u http://dvwa/vulnerabilities/sqli/?id=1"
echo ""

