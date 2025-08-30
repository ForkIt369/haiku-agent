#!/usr/bin/env python3
import requests
import json
import base64
from requests.auth import HTTPBasicAuth

# Configuration
N8N_URL = "https://n8n-production-de44.up.railway.app"
USERNAME = "admin"
PASSWORD = "changeme123"

def main():
    print("🚀 Importing HAIKU Agent workflow to n8n...")
    
    # Load workflow
    with open('n8n/workflows/haiku-agent-mvp.json', 'r') as f:
        workflow = json.load(f)
    
    # Remove the id field for import
    if 'id' in workflow:
        del workflow['id']
    
    # API endpoint
    url = f"{N8N_URL}/rest/workflows"
    
    # Try to import workflow
    try:
        response = requests.post(
            url,
            json=workflow,
            auth=HTTPBasicAuth(USERNAME, PASSWORD),
            headers={'Content-Type': 'application/json'},
            timeout=30
        )
        
        if response.status_code == 200 or response.status_code == 201:
            result = response.json()
            workflow_id = result.get('id')
            print(f"✅ Workflow imported successfully! ID: {workflow_id}")
            
            # Now activate it
            activate_url = f"{N8N_URL}/rest/workflows/{workflow_id}"
            activate_response = requests.patch(
                activate_url,
                json={"active": True},
                auth=HTTPBasicAuth(USERNAME, PASSWORD),
                headers={'Content-Type': 'application/json'}
            )
            
            if activate_response.status_code == 200:
                print("✅ Workflow activated!")
                print(f"\n🎉 Your webhook URL is: {N8N_URL}/webhook/haiku-chat")
                
                # Test the webhook
                print("\n🧪 Testing webhook...")
                test_webhook()
            else:
                print(f"⚠️ Could not activate workflow: {activate_response.text}")
                
        else:
            print(f"❌ Failed to import workflow: {response.status_code}")
            print(f"Response: {response.text}")
            
    except Exception as e:
        print(f"❌ Error: {str(e)}")

def test_webhook():
    webhook_url = f"{N8N_URL}/webhook/haiku-chat"
    test_data = {
        "message": "Hello! Can you help me test the HAIKU Agent?",
        "personality": "BigSis",
        "userId": "test-user",
        "sessionId": "test-session"
    }
    
    try:
        response = requests.post(webhook_url, json=test_data, timeout=10)
        if response.status_code == 200:
            result = response.json()
            print("✅ Webhook test successful!")
            print(f"Response: {result.get('message', 'No message in response')[:100]}...")
        else:
            print(f"⚠️ Webhook returned status {response.status_code}")
    except Exception as e:
        print(f"⚠️ Webhook test failed: {str(e)}")

if __name__ == "__main__":
    main()