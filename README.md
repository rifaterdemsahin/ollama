# 🦙 Ollama Self-Learning System

> **Master Local LLM Deployment with Ollama** — A structured 7-stage journey from **Unknown** to **Proven**.

[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Live-green)](https://rifaterdemsahin.github.io/ollama/)

## 🗺️ The 7-Stage Journey

| Stage | Folder | The Role | Description |
|-------|--------|----------|-------------|
| 1 | `1_Real_Unknown` | 🌍 The Why | OKRs, problem definitions, core questions |
| 2 | `2_Environment` | 🌳 The Context | Setup guides, Ollama + Qdrant config |
| 3 | `3_Simulation` | 🌌 The Vision | UI mockups, image carousel |
| 4 | `4_Formula` | 📐 The Recipe | Step-by-step guides, install docs |
| 5 | `5_Symbols` | 🔣 The Reality | Source code, API examples, PrismJS |
| 6 | `6_Semblance` | 🌀 The Scars | Error logs, near-misses, workarounds |
| 7 | `7_Testing_Known` | 🧪 The Proof | Validation against OKRs, checklists |

**Flow:** 🌍 Real Unknown → 🌳 Environment → 🌌 Simulation → 📐 Formula → 🔣 Symbols → 🌀 Semblance → 🧪 Testing Known

## 🤖 AI Stack

- **Ollama** — Local LLM inference (`http://localhost:11434`)
- **Qdrant** — Vector database with `nomic-embed-text` (4096 dims)
- **Models**: `llama3.2`, `nomic-embed-text`, + others

## 🚀 Quick Start

```bash
# 1. Clone
git clone https://github.com/rifaterdemsahin/ollama.git
cd ollama

# 2. Open in browser (static site, no server needed)
open index.html
# or visit: https://rifaterdemsahin.github.io/ollama/

# 3. Install Ollama (macOS)
brew install ollama
ollama serve

# 4. Pull models
ollama pull llama3.2
ollama pull nomic-embed-text
```

## 📐 Root Files

| File | Purpose |
|------|---------|
| `index.html` | Main entry point |
| `markdown_renderer.html` | View any `.md` file |
| `nav.js` | Shared navigation component |
| `nav.css` | Shared styles |
| `nav_config.json` | Navigation and search config |
| `aigent.md` | AI agent rules |
| `claude.md` | Claude persona rules |
| `.env` | Environment variable template |
| `.github/workflows/pages.yml` | GitHub Pages CI/CD |

## 🔗 Connect

- ⬛ [GitHub](https://github.com/rifaterdemsahin/ollama)
- 🔗 [LinkedIn — rifaterdemsahin](https://www.linkedin.com/in/rifaterdemsahin)
- 📺 [YouTube — @RifatErdemSahin](https://www.youtube.com/@RifatErdemSahin)

## 🔄 Git Workflow

```bash
git pull; git add . && git commit -m "describe change" && git push
```
