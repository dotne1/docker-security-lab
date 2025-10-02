#!/usr/bin/env python3
"""
Grok-Code API Server for Security Lab
Provides REST API endpoints for AI-powered security assistance
"""

import os
import json
import logging
from flask import Flask, request, jsonify, Response
from flask_cors import CORS
from dotenv import load_dotenv
from client import GrokCodeClient

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)  # Enable CORS for frontend integration

# Initialize Grok client
try:
    grok_client = GrokCodeClient()
    logger.info("Grok-Code client initialized successfully")
except Exception as e:
    logger.error(f"Failed to initialize Grok-Code client: {e}")
    grok_client = None

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    if grok_client is None:
        return jsonify({
            "status": "unhealthy",
            "service": "grok-code-api",
            "error": "Grok client not initialized"
        }), 500
    
    try:
        is_healthy = grok_client.health_check()
        return jsonify({
            "status": "healthy" if is_healthy else "unhealthy",
            "service": "grok-code-api",
            "configured": True
        }), 200 if is_healthy else 500
    except Exception as e:
        return jsonify({
            "status": "unhealthy",
            "service": "grok-code-api",
            "error": str(e)
        }), 500

@app.route('/v1/models', methods=['GET'])
def list_models():
    """List available Grok models"""
    if grok_client is None:
        return jsonify({"error": "Grok client not initialized"}), 500
    
    models = []
    for model_id, description in grok_client.models.items():
        models.append({
            "id": model_id,
            "object": "model",
            "owned_by": "xai",
            "description": description
        })
    
    return jsonify({
        "object": "list",
        "data": models
    })

@app.route('/v1/chat/completions', methods=['POST'])
def chat_completions():
    """OpenAI-compatible chat completions endpoint"""
    if grok_client is None:
        return jsonify({"error": "Grok client not initialized"}), 500
    
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "No JSON data provided"}), 400
        
        # Extract parameters
        messages = data.get("messages", [])
        model = data.get("model", "grok-code-fast-1")
        temperature = data.get("temperature", 0.7)
        max_tokens = data.get("max_tokens", 2000)
        
        if not messages:
            return jsonify({"error": "Messages required"}), 400
        
        # Call Grok API
        response = grok_client.chat_completion(
            messages=messages,
            model=model,
            temperature=temperature,
            max_tokens=max_tokens
        )
        
        return jsonify(response), 200
        
    except Exception as e:
        logger.error(f"Chat completion error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/v1/analyze', methods=['POST'])
def analyze_vulnerability():
    """Analyze code for security vulnerabilities"""
    if grok_client is None:
        return jsonify({"error": "Grok client not initialized"}), 500
    
    try:
        data = request.get_json()
        code = data.get("code", "")
        language = data.get("language", "python")
        
        if not code:
            return jsonify({"error": "Code required"}), 400
        
        analysis = grok_client.analyze_vulnerability(code, language)
        
        return jsonify({
            "analysis": analysis,
            "language": language,
            "model": "grok-code-fast-1"
        }), 200
        
    except Exception as e:
        logger.error(f"Vulnerability analysis error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/v1/explain', methods=['POST'])
def explain_concept():
    """Explain security concepts"""
    if grok_client is None:
        return jsonify({"error": "Grok client not initialized"}), 500
    
    try:
        data = request.get_json()
        concept = data.get("concept", "")
        
        if not concept:
            return jsonify({"error": "Concept required"}), 400
        
        explanation = grok_client.explain_security_concept(concept)
        
        return jsonify({
            "concept": concept,
            "explanation": explanation,
            "model": "grok-3-latest"
        }), 200
        
    except Exception as e:
        logger.error(f"Concept explanation error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/v1/exploit', methods=['POST'])
def suggest_exploit():
    """Suggest educational exploit techniques"""
    if grok_client is None:
        return jsonify({"error": "Grok client not initialized"}), 500
    
    try:
        data = request.get_json()
        vulnerability = data.get("vulnerability", "")
        context = data.get("context", "")
        
        if not vulnerability:
            return jsonify({"error": "Vulnerability type required"}), 400
        
        suggestions = grok_client.suggest_exploit(vulnerability, context)
        
        return jsonify({
            "vulnerability": vulnerability,
            "context": context,
            "suggestions": suggestions,
            "model": "grok-code-fast-1",
            "disclaimer": "Educational purposes only - use only in controlled lab environments"
        }), 200
        
    except Exception as e:
        logger.error(f"Exploit suggestion error: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/v1/payload', methods=['POST'])
def generate_payload():
    """Generate educational payloads"""
    if grok_client is None:
        return jsonify({"error": "Grok client not initialized"}), 500
    
    try:
        data = request.get_json()
        vulnerability_type = data.get("vulnerability_type", "")
        target_info = data.get("target_info", "")
        
        if not vulnerability_type:
            return jsonify({"error": "Vulnerability type required"}), 400
        
        payloads = grok_client.generate_payload(vulnerability_type, target_info)
        
        return jsonify({
            "vulnerability_type": vulnerability_type,
            "target_info": target_info,
            "payloads": payloads,
            "model": "grok-code-fast-1",
            "disclaimer": "Educational purposes only - use only in controlled lab environments"
        }), 200
        
    except Exception as e:
        logger.error(f"Payload generation error: {e}")
        return jsonify({"error": str(e)}), 500

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({
        "error": "Endpoint not found",
        "available_endpoints": [
            "/health",
            "/v1/models",
            "/v1/chat/completions",
            "/v1/analyze",
            "/v1/explain",
            "/v1/exploit",
            "/v1/payload"
        ]
    }), 404

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return jsonify({
        "error": "Internal server error",
        "message": "Check server logs for details"
    }), 500

if __name__ == '__main__':
    logger.info("Starting Grok-Code API Server on port 8180")
    logger.info(f"Grok client initialized: {grok_client is not None}")
    
    app.run(host='0.0.0.0', port=8180, debug=False)
