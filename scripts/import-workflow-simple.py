#!/usr/bin/env python3
import json
import base64
import urllib.request
import urllib.error
import ssl

# Configuration
N8N_URL = "https://n8n-production-de44.up.railway.app"
USERNAME = "admin"
PASSWORD = "changeme123"

# Create SSL context to handle HTTPS
ssl_context = ssl.create_default_context()

def main():
    print("🚀 Importing HAIKU Agent workflow to n8n...")
    
    # Load workflow
    with open('n8n/workflows/haiku-agent-mvp.json', 'r') as f:
        workflow = json.load(f)
    
    # Remove the id field for import
    if 'id' in workflow:
        del workflow['id']
    
    # Prepare authentication
    credentials = base64.b64encode(f"{USERNAME}:{PASSWORD}".encode()).decode()
    
    # API endpoint
    url = f"{N8N_URL}/rest/workflows"
    
    # Prepare request
    data = json.dumps(workflow).encode('utf-8')
    request = urllib.request.Request(
        url,
        data=data,
        headers={
            'Content-Type': 'application/json',
            'Authorization': f'Basic {credentials}'
        }
    )
    
    try:
        # Send request
        with urllib.request.urlopen(request, context=ssl_context) as response:
            result = json.loads(response.read().decode())
            workflow_id = result.get('id')
            print(f"✅ Workflow imported successfully! ID: {workflow_id}")
            
            # Now activate it
            activate_workflow(workflow_id, credentials)
            
    except urllib.error.HTTPError as e:
        print(f"❌ HTTP Error {e.code}: {e.reason}")
        if e.code == 401:
            print("Authentication failed. Please check credentials.")
        try:
            error_body = e.read().decode()
            print(f"Error details: {error_body}")
        except:
            pass
    except Exception as e:
        print(f"❌ Error: {str(e)}")

def activate_workflow(workflow_id, credentials):
    print(f"Activating workflow {workflow_id}...")
    
    url = f"{N8N_URL}/rest/workflows/{workflow_id}"
    data = json.dumps({"active": True}).encode('utf-8')
    
    request = urllib.request.Request(
        url,
        data=data,
        headers={
            'Content-Type': 'application/json',
            'Authorization': f'Basic {credentials}'
        },
        method='PATCH'
    )
    
    try:
        with urllib.request.urlopen(request, context=ssl_context) as response:
            print("✅ Workflow activated!")
            print(f"\n🎉 Your webhook URL is: {N8N_URL}/webhook/haiku-chat")
            print("\n🧪 Testing webhook...")
            test_webhook()
    except Exception as e:
        print(f"⚠️ Could not activate workflow: {str(e)}")

def test_webhook():
    webhook_url = f"{N8N_URL}/webhook/haiku-chat"
    test_data = {
        "message": "Hello! Testing HAIKU Agent.",
        "personality": "BigSis",
        "userId": "test-user"
    }
    
    data = json.dumps(test_data).encode('utf-8')
    request = urllib.request.Request(
        webhook_url,
        data=data,
        headers={'Content-Type': 'application/json'}
    )
    
    try:
        with urllib.request.urlopen(request, context=ssl_context, timeout=10) as response:
            result = json.loads(response.read().decode())
            print("✅ Webhook test successful!")
            message = result.get('message', 'No message')
            print(f"Response: {message[:100]}...")
    except Exception as e:
        print(f"⚠️ Webhook test failed: {str(e)}")

if __name__ == "__main__":
    main()