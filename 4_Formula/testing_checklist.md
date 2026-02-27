# 🧪 Testing Checklist — Stage 4: Formula

> **YouTube Reference:** [Ollama Full Tutorial](https://www.youtube.com/results?search_query=ollama+complete+tutorial+local+llm) — Complete walkthrough of Ollama setup and usage.

## ✅ Installation Guide Validation

- [ ] macOS installation via Homebrew documented
- [ ] macOS installation via curl installer documented
- [ ] Linux one-line installer documented
- [ ] Windows installer download link documented
- [ ] All install steps tested and verified working

## ✅ Prerequisites Documented

- [ ] Minimum RAM (8GB) specified
- [ ] Recommended RAM (16GB) specified
- [ ] Minimum disk space (10GB) specified
- [ ] macOS version requirement (12.0+) specified
- [ ] Docker requirement for Qdrant documented

## ✅ Features Reference

- [ ] Model management commands listed (`pull`, `run`, `list`, `rm`)
- [ ] API endpoints documented (`/api/generate`, `/api/embeddings`, `/api/chat`)
- [ ] Qdrant integration steps covered
- [ ] nomic-embed-text embedding workflow documented

## ✅ Quick Start Steps Verified

- [ ] Step 1: Install — tested on target platform
- [ ] Step 2: `ollama --version` returns correct version
- [ ] Step 3: `ollama serve` starts without errors
- [ ] Step 4: `ollama pull llama3.2` completes
- [ ] Step 5: Test query returns a response

## ✅ Troubleshooting Coverage

- [ ] Port conflict resolution documented
- [ ] Permission issues documented
- [ ] Memory constraint workarounds documented
- [ ] All errors in Stage 6 (Semblance) have a corresponding fix here

## 📊 Guide Completeness

| Guide | Status |
|-------|--------|
| install.md | ✅ Complete |
| prerequisites.md | ✅ Complete |
| features.md | ✅ Complete |

## 🔗 Related Pages

- [Symbols (Implementation) →](../5_Symbols/index.html)
- [Semblance (Errors) →](../6_Semblance/index.html)
- [View Install Guide](../markdown_renderer.html?file=4_Formula/install.md)
