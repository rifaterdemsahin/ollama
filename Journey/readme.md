# Step-by-Step Ollama Implementation Guide for MacBook

## Prerequisites
- MacBook with macOS 12.0 or later
- At least 8GB RAM (16GB recommended)
- Minimum 10GB free disk space
- Terminal access

## Installation Steps

### 1. Install Ollama
1. Download Ollama
   ```bash
   curl https://ollama.ai/install.sh | sh
   ```

2. Verify Installation
   ```bash
   ollama --version
   ```

3. Start Ollama Service
   ```bash
   ollama serve
   ```

4. Pull Your First Model
   ```bash
   # In a new terminal window
   ollama pull llama2
   ```

5. Test the Installation
   ```bash
   ollama run llama2 "Hello, how are you?"
   ```

Note: If you encounter any permission issues, you may need to use `sudo` for the installation command.

Troubleshooting:
- If Ollama fails to start, ensure no other services are using port 11434
- Check system requirements are met (especially RAM and disk space)
- Verify your macOS version is 12.0 or later
