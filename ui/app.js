// HAIKU Agent - Frontend Application
class HAIKUAgent {
    constructor() {
        // Configuration
        this.webhookUrl = window.WEBHOOK_URL || 'https://your-n8n.railway.app/webhook/haiku-chat';
        this.sessionId = this.getOrCreateSessionId();
        this.currentPersonality = 'BigSis';
        this.memory = [];
        this.totalCost = 0;
        
        // DOM Elements
        this.elements = {
            chatMessages: document.getElementById('chatMessages'),
            messageInput: document.getElementById('messageInput'),
            sendBtn: document.getElementById('sendBtn'),
            loadingIndicator: document.getElementById('loadingIndicator'),
            modelStatus: document.getElementById('modelStatus'),
            memoryStatus: document.getElementById('memoryStatus'),
            costStatus: document.getElementById('costStatus'),
            connectionStatus: document.getElementById('connectionStatus'),
            personalityBtns: document.querySelectorAll('.personality-btn')
        };
        
        // Initialize
        this.init();
    }
    
    init() {
        // Load memory from localStorage
        this.loadMemory();
        
        // Event listeners
        this.elements.sendBtn.addEventListener('click', () => this.sendMessage());
        this.elements.messageInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') this.sendMessage();
        });
        
        // Personality selector
        this.elements.personalityBtns.forEach(btn => {
            btn.addEventListener('click', () => this.switchPersonality(btn));
        });
        
        // Update status
        this.updateStatus();
        
        // Focus input
        this.elements.messageInput.focus();
    }
    
    getOrCreateSessionId() {
        let sessionId = localStorage.getItem('haiku_session_id');
        if (!sessionId) {
            sessionId = `session_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
            localStorage.setItem('haiku_session_id', sessionId);
        }
        return sessionId;
    }
    
    loadMemory() {
        const stored = localStorage.getItem('haiku_memory');
        if (stored) {
            try {
                this.memory = JSON.parse(stored);
                // Restore previous messages in UI
                this.memory.forEach(msg => {
                    if (msg.role === 'user' || msg.role === 'assistant') {
                        this.addMessageToUI(msg.content, msg.role === 'user');
                    }
                });
            } catch (e) {
                console.error('Failed to load memory:', e);
                this.memory = [];
            }
        }
    }
    
    saveMemory() {
        // Keep only last 20 messages
        this.memory = this.memory.slice(-20);
        localStorage.setItem('haiku_memory', JSON.stringify(this.memory));
    }
    
    switchPersonality(btn) {
        // Update active state
        this.elements.personalityBtns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        
        // Update current personality
        this.currentPersonality = btn.dataset.personality;
        
        // Update accent color
        document.documentElement.style.setProperty('--accent', btn.dataset.color);
        
        // Add system message
        this.addMessageToUI(`Switched to ${this.currentPersonality} personality`, false, true);
    }
    
    async sendMessage() {
        const message = this.elements.messageInput.value.trim();
        if (!message) return;
        
        // Add user message to UI
        this.addMessageToUI(message, true);
        
        // Clear input
        this.elements.messageInput.value = '';
        
        // Show loading
        this.setLoading(true);
        this.updateConnectionStatus('Processing...', '#FE5F00');
        
        // Add to memory
        this.memory.push({
            role: 'user',
            content: message,
            timestamp: new Date().toISOString()
        });
        
        try {
            // Send to webhook
            const response = await fetch(this.webhookUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    message: message,
                    userId: 'web-user',
                    sessionId: this.sessionId,
                    personality: this.currentPersonality,
                    memory: this.memory
                })
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            
            // Add assistant response to UI
            this.addMessageToUI(data.message, false);
            
            // Update memory
            if (data.memory) {
                this.memory = data.memory;
            } else {
                this.memory.push({
                    role: 'assistant',
                    content: data.message,
                    timestamp: new Date().toISOString()
                });
            }
            
            // Update metrics
            if (data.metadata) {
                this.updateMetrics(data.metadata);
            }
            
            // Save memory
            this.saveMemory();
            
            // Update status
            this.updateConnectionStatus('Ready', '#3EB85F');
            
        } catch (error) {
            console.error('Error sending message:', error);
            this.addMessageToUI('Sorry, I encountered an error. Please try again.', false, true);
            this.updateConnectionStatus('Error', '#EF4444');
        } finally {
            this.setLoading(false);
        }
    }
    
    addMessageToUI(content, isUser = false, isSystem = false) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${isUser ? 'user' : 'assistant'}`;
        
        const avatarDiv = document.createElement('div');
        avatarDiv.className = 'message-avatar';
        
        if (isUser) {
            avatarDiv.textContent = 'You';
            avatarDiv.style.backgroundColor = '#393939';
        } else if (isSystem) {
            avatarDiv.textContent = '⚙️';
            avatarDiv.style.backgroundColor = '#9ca3af';
        } else {
            // Use personality color
            const colors = {
                'BigSis': '#00A1F1',
                'Bro': '#FE5F00',
                'LilSis': '#7E3AF2',
                'CBO': '#3EB85F'
            };
            avatarDiv.textContent = 'AI';
            avatarDiv.style.backgroundColor = colors[this.currentPersonality] || '#00A1F1';
        }
        
        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        
        const textP = document.createElement('p');
        textP.textContent = content;
        
        const timeSpan = document.createElement('span');
        timeSpan.className = 'message-time';
        timeSpan.textContent = this.formatTime(new Date());
        
        contentDiv.appendChild(textP);
        contentDiv.appendChild(timeSpan);
        
        messageDiv.appendChild(avatarDiv);
        messageDiv.appendChild(contentDiv);
        
        this.elements.chatMessages.appendChild(messageDiv);
        
        // Scroll to bottom
        this.elements.chatMessages.scrollTop = this.elements.chatMessages.scrollHeight;
    }
    
    updateMetrics(metadata) {
        // Update model
        if (metadata.model) {
            this.elements.modelStatus.textContent = metadata.model.split('/').pop();
        }
        
        // Update cost
        if (metadata.cost) {
            this.totalCost += parseFloat(metadata.cost);
            this.elements.costStatus.textContent = `$${this.totalCost.toFixed(4)}`;
        }
        
        // Update memory count
        this.updateStatus();
    }
    
    updateStatus() {
        // Update memory status
        this.elements.memoryStatus.textContent = `${this.memory.length}/20`;
    }
    
    updateConnectionStatus(status, color) {
        this.elements.connectionStatus.textContent = status;
        this.elements.connectionStatus.style.setProperty('--status-color', color);
    }
    
    setLoading(isLoading) {
        if (isLoading) {
            this.elements.loadingIndicator.classList.add('active');
            this.elements.sendBtn.disabled = true;
            this.elements.messageInput.disabled = true;
        } else {
            this.elements.loadingIndicator.classList.remove('active');
            this.elements.sendBtn.disabled = false;
            this.elements.messageInput.disabled = false;
            this.elements.messageInput.focus();
        }
    }
    
    formatTime(date) {
        const now = new Date();
        const diff = now - date;
        
        if (diff < 60000) return 'Just now';
        if (diff < 3600000) return `${Math.floor(diff / 60000)} min ago`;
        if (diff < 86400000) return `${Math.floor(diff / 3600000)} hours ago`;
        
        return date.toLocaleDateString();
    }
}

// Configuration (set your webhook URL here)
window.WEBHOOK_URL = 'https://n8n-production-de44.up.railway.app/webhook/haiku-chat';

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.haikuAgent = new HAIKUAgent();
});