FROM n8nio/n8n:latest

# Add custom workflows directory
COPY workflows /workflows

# Set environment variables
ENV N8N_HOST=0.0.0.0 \
    N8N_PORT=5678 \
    N8N_PROTOCOL=http \
    EXECUTIONS_MODE=regular \
    N8N_PERSONALIZATION_ENABLED=false \
    N8N_VERSION_NOTIFICATIONS_ENABLED=false \
    N8N_DIAGNOSTICS_ENABLED=false

# Create volume for data persistence
VOLUME ["/home/node/.n8n"]

# Expose port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Start n8n
CMD ["n8n", "start"]