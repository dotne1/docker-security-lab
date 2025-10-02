#!/usr/bin/env python3
"""
Grok-Code API Client for Security Lab
Professional integration with xAI's Grok models for security assistance
"""

import os
import json
import logging
from typing import Dict, List, Optional, Any
import requests
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class GrokCodeClient:
    """Professional client for xAI's Grok-Code API"""
    
    def __init__(self, api_key: Optional[str] = None):
        """
        Initialize Grok-Code client
        
        Args:
            api_key: xAI API key. If None, will try to load from GROK_API_KEY env var
        """
        self.api_key = api_key or os.getenv("GROK_API_KEY")
        if not self.api_key:
            raise ValueError("API key required. Set GROK_API_KEY environment variable or pass api_key parameter")
        
        self.base_url = "https://api.x.ai/v1"
        self.headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {self.api_key}"
        }
        
        # Available models
        self.models = {
            "grok-code-fast-1": "Fast coding model",
            "grok-4-latest": "Latest Grok-4 model", 
            "grok-3-latest": "Latest Grok-3 model",
            "grok-3-fast": "Fast Grok-3 model"
        }
        
        logger.info("Grok-Code client initialized")
    
    def chat_completion(
        self,
        messages: List[Dict[str, str]],
        model: str = "grok-code-fast-1",
        temperature: float = 0.7,
        max_tokens: int = 2000,
        stream: bool = False
    ) -> Dict[str, Any]:
        """
        Send chat completion request to Grok API
        
        Args:
            messages: List of message dictionaries with 'role' and 'content'
            model: Model to use (default: grok-code-fast-1)
            temperature: Sampling temperature (0.0 to 1.0)
            max_tokens: Maximum tokens to generate
            stream: Whether to stream response
            
        Returns:
            API response dictionary
        """
        if model not in self.models:
            raise ValueError(f"Unknown model: {model}. Available: {list(self.models.keys())}")
        
        payload = {
            "messages": messages,
            "model": model,
            "temperature": temperature,
            "max_tokens": max_tokens,
            "stream": stream
        }
        
        try:
            logger.info(f"Sending request to Grok API with model: {model}")
            response = requests.post(
                f"{self.base_url}/chat/completions",
                headers=self.headers,
                json=payload,
                timeout=60
            )
            response.raise_for_status()
            return response.json()
            
        except requests.exceptions.RequestException as e:
            logger.error(f"API request failed: {e}")
            raise
    
    def analyze_vulnerability(self, code: str, language: str = "python") -> str:
        """
        Analyze code for security vulnerabilities
        
        Args:
            code: Code to analyze
            language: Programming language
            
        Returns:
            Vulnerability analysis
        """
        messages = [
            {
                "role": "system",
                "content": f"""You are a security expert analyzing {language} code for vulnerabilities. 
                Focus on:
                - Input validation issues
                - Injection vulnerabilities
                - Authentication/authorization flaws
                - Cryptographic weaknesses
                - Memory safety issues
                
                Provide specific, actionable recommendations."""
            },
            {
                "role": "user", 
                "content": f"Analyze this {language} code for security vulnerabilities:\n\n```{language}\n{code}\n```"
            }
        ]
        
        response = self.chat_completion(messages, model="grok-code-fast-1")
        return response["choices"][0]["message"]["content"]
    
    def explain_security_concept(self, concept: str) -> str:
        """
        Explain a security concept in simple terms
        
        Args:
            concept: Security concept to explain
            
        Returns:
            Explanation of the concept
        """
        messages = [
            {
                "role": "system",
                "content": "You are a security educator. Explain security concepts clearly and practically, with examples when helpful."
            },
            {
                "role": "user",
                "content": f"Explain this security concept: {concept}"
            }
        ]
        
        response = self.chat_completion(messages, model="grok-3-latest")
        return response["choices"][0]["message"]["content"]
    
    def suggest_exploit(self, vulnerability: str, context: str = "") -> str:
        """
        Suggest educational exploit techniques (for lab environment only)
        
        Args:
            vulnerability: Type of vulnerability
            context: Additional context about the target
            
        Returns:
            Educational exploit suggestions
        """
        messages = [
            {
                "role": "system",
                "content": """You are a security researcher providing educational exploit techniques for a controlled lab environment.
                Focus on:
                - Educational value
                - Safe testing methods
                - Understanding attack vectors
                - Defensive measures
                
                Always emphasize this is for educational purposes only."""
            },
            {
                "role": "user",
                "content": f"Suggest educational exploit techniques for: {vulnerability}\n\nContext: {context}"
            }
        ]
        
        response = self.chat_completion(messages, model="grok-code-fast-1")
        return response["choices"][0]["message"]["content"]
    
    def generate_payload(self, vulnerability_type: str, target_info: str = "") -> str:
        """
        Generate educational payloads for testing
        
        Args:
            vulnerability_type: Type of vulnerability (e.g., "SQL injection", "XSS")
            target_info: Information about the target
            
        Returns:
            Educational payload examples
        """
        messages = [
            {
                "role": "system",
                "content": """You are a security researcher generating educational payloads for controlled testing.
                Provide:
                - Multiple payload variations
                - Explanation of how each works
                - Detection methods
                - Mitigation strategies
                
                Always emphasize educational use only."""
            },
            {
                "role": "user",
                "content": f"Generate educational payloads for {vulnerability_type} testing.\n\nTarget info: {target_info}"
            }
        ]
        
        response = self.chat_completion(messages, model="grok-code-fast-1")
        return response["choices"][0]["message"]["content"]
    
    def health_check(self) -> bool:
        """
        Check if API is accessible
        
        Returns:
            True if API is accessible, False otherwise
        """
        try:
            messages = [{"role": "user", "content": "Hello"}]
            response = self.chat_completion(messages, max_tokens=10)
            return True
        except Exception as e:
            logger.error(f"Health check failed: {e}")
            return False

def main():
    """Example usage of Grok-Code client"""
    try:
        # Initialize client
        client = GrokCodeClient()
        
        # Health check
        if not client.health_check():
            print("❌ API health check failed")
            return
        
        print("✅ Grok-Code API is accessible")
        
        # Example: Analyze vulnerable code
        vulnerable_code = """
import os
user_input = input("Enter filename: ")
os.system(f"cat {user_input}")
        """
        
        print("\n🔍 Analyzing vulnerable code...")
        analysis = client.analyze_vulnerability(vulnerable_code, "python")
        print(f"Analysis: {analysis}")
        
        # Example: Explain security concept
        print("\n📚 Explaining security concept...")
        explanation = client.explain_security_concept("SQL injection")
        print(f"Explanation: {explanation}")
        
    except Exception as e:
        logger.error(f"Error: {e}")

if __name__ == "__main__":
    main()
