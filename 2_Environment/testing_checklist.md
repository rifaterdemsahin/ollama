# 🧪 Testing Checklist — Stage 2: Environment

> **YouTube Reference:** [Ollama Installation Guide](https://www.youtube.com/results?search_query=ollama+local+llm+installation+guide) — Step-by-step Ollama setup across platforms.

## ✅ Ollama Installation

### macOS
- [ ] `brew install ollama` or curl installer executed successfully
- [ ] `ollama --version` returns a version number
- [ ] `ollama serve` starts without errors on port 11434
- [ ] `ollama pull llama3.2` completes successfully
- [ ] `ollama run llama3.2 "Hello"` returns a response

### Linux
- [ ] `curl -fsSL https://ollama.com/install.sh | sh` runs successfully
- [ ] systemd service starts and is enabled
- [ ] Port 11434 is accessible

### Windows
- [ ] Installer downloaded and executed
- [ ] Ollama runs in system tray
- [ ] Port 11434 accessible from browser

## ✅ Qdrant Vector Database

- [ ] Docker installed and running
- [ ] `docker pull qdrant/qdrant` succeeds
- [ ] Qdrant container starts on ports 6333/6334
- [ ] Qdrant dashboard accessible at `http://localhost:6333/dashboard`
- [ ] API endpoint responds at `http://localhost:6333/collections`

## ✅ nomic-embed-text

- [ ] `ollama pull nomic-embed-text` completes
- [ ] Embedding API call returns 4096-dimension vector
- [ ] Embeddings can be stored in Qdrant collection

## ✅ AI Client Configuration

- [ ] Ollama API endpoint accessible at `http://localhost:11434`
- [ ] `claude.md` persona rules defined
- [ ] Obsidian shortcut title generation via Ollama tested

## 📊 Environment Validation

| Component | Expected | Verified |
|-----------|----------|----------|
| Ollama | Running on :11434 | 🔲 |
| Qdrant | Running on :6333 | 🔲 |
| nomic-embed-text | Loaded, 4096 dims | 🔲 |
| Docker | Running | 🔲 |

## 🔗 Related Pages

- [Real Unknown (Why?) →](../1_Real_Unknown/index.html)
- [Formula (How?) →](../4_Formula/index.html)
- [View Readme Source](../markdown_renderer.html?file=2_Environment/readme.md)
