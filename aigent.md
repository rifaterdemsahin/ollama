# 🤖 AI Agent Rules — Ollama Self-Learning System

## Project Context

This repository follows the **7-Stage Self-Learning Framework**:
1. `1_Real_Unknown` — Problem definitions and OKRs
2. `2_Environment` — Setup and configuration
3. `3_Simulation` — Vision and mockups
4. `4_Formula` — Step-by-step guides
5. `5_Symbols` — Source code and implementation
6. `6_Semblance` — Error logs and workarounds
7. `7_Testing_Known` — Validation and proof

## AI Task Instructions

### When Populating Qdrant

- Use `nomic-embed-text` model via Ollama (4096 dimensions)
- Qdrant endpoint: `http://localhost:6333`
- Collection name: `ollama_notes`
- Always verify embedding dimensions match collection config

### When Generating Obsidian Titles

- Use Ollama local inference (default: `llama3.2`)
- Keep titles concise (5-10 words)
- Use the Obsidian naming convention: `Title Case With Dashes.md`
- No special characters except hyphens and underscores

### When Writing Code

- Prefer Python for AI/ML tasks
- Prefer bash/curl for quick API testing
- All code goes in `5_Symbols/`
- Document any new symbols in `5_Symbols/readme.md`

### When Documenting Errors

- All errors go in `6_Semblance/`
- Use the error card format: Title, Context, Fix
- Tag status: `Resolved` / `Known Issue` / `Intermittent`

### Commit Convention

```
git pull; git add . && git commit -m "describe what changed" && git push
```

## Forbidden Actions

- Do NOT commit secrets or API keys
- Do NOT delete files from `6_Semblance/` (errors have learning value)
- Do NOT skip the testing checklist in Stage 7
- Do NOT make breaking changes to `nav.js` or `nav.css` without updating all pages
