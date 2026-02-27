# 🧪 Testing Checklist — Stage 6: Semblance

> **YouTube Reference:** [Debugging LLM Applications](https://www.youtube.com/results?search_query=debugging+ollama+local+llm+errors) — Common errors and how to fix them in Ollama deployments.

## ✅ Error Documentation

- [ ] All errors have a clear title describing the symptom
- [ ] Each error has reproduction steps or context
- [ ] Each error has a documented fix or workaround
- [ ] Errors are tagged by status (Resolved/Known/Intermittent)
- [ ] Linux-only install script error documented and resolved
- [ ] Memory-related errors documented with fixes
- [ ] Port conflict resolution documented

## ✅ Near-Miss Documentation

- [ ] Wrong domain/URL confusion documented
- [ ] Qdrant dimension mismatch documented
- [ ] Any configuration gotchas captured

## ✅ Plan vs Reality Analysis

- [ ] At least one "Planned vs Reality" comparison documented
- [ ] Lessons learned are actionable
- [ ] Fixes traced back to Formula (Stage 4) updates

## ✅ Obsolete Items

- [ ] Obsolete error records moved to `6_Semblance/_obsolete/`
- [ ] Resolved errors marked clearly (not deleted — they have learning value)

## 📊 Error Log Status

| Error | Status | Fix Documented |
|-------|--------|---------------|
| Linux-only install on macOS | ✅ Resolved | ✅ |
| Docker memory limits | ⚠️ Known | ✅ |
| CUDA OOM vision models | ⚠️ Known | ✅ |
| unsafe.Slice nil pointer | 🔄 Intermittent | ✅ Workaround |
| Port 11434 in use | ✅ Resolved | ✅ |

## 🔗 Related Pages

- [Formula (Fixes) →](../4_Formula/index.html)
- [Testing Known (Proof) →](../7_Testing_Known/index.html)
- [View Error Readme](../markdown_renderer.html?file=6_Semblance/readme.md)
