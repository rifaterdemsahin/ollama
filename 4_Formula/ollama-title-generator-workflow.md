# 📐 Formula: Ollama Title Generator + Git Workflow

## 🎯 Purpose

Automate the process of generating intelligent file titles from clipboard content using Ollama, then automatically committing and pushing to Git.

## 🔣 Components

### Required Services
- **Ollama** running on `http://localhost:11434`
- **llama3.2** model (for title generation)
- **Git** repository initialized

### Script Location
`get-title-and-commit.ps1`

## 🛠 The Recipe

### Step 1: Clipboard → Ollama
```powershell
$clipboardContent = Get-Clipboard -Raw
```

### Step 2: API Call to Ollama
```powershell
$ollamaUrl = "http://localhost:11434/api/generate"
$body = @{
    model = "llama3.2"
    prompt = "Generate a short, descriptive title (5-8 words maximum)..."
    stream = $false
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri $ollamaUrl -Method Post -Body $body -ContentType "application/json"
```

### Step 3: Title → Filename Sanitization
```powershell
$title = $response.response.Trim()
$filename = $title -replace '[\\/:*?"<>|]', '-' -replace '\s+', '-'
$filename = "$filename.md"
```

### Step 4: Create Markdown File
```powershell
$clipboardContent | Out-File -FilePath $filename -Encoding UTF8
```

### Step 5: Git Workflow
```powershell
git add $filename
git commit -m "Add $title"
git push
```

## ✨ Usage

```powershell
# 1. Copy content to clipboard (Ctrl+C)
# 2. Run the script
.\get-title-and-commit.ps1
```

## 🧪 Example Flow

**Input (Clipboard):**
```
This is a guide about setting up Qdrant vector database
with Ollama embeddings for semantic search...
```

**Output:**
- **Generated Title:** "Qdrant Ollama Semantic Search Setup"
- **Filename:** `Qdrant-Ollama-Semantic-Search-Setup.md`
- **Git Commit:** "Add Qdrant Ollama Semantic Search Setup"
- **Result:** File pushed to remote repository

## 🌀 Error Handling

- ❌ Empty clipboard → Exit with error
- ❌ Ollama API failure → Display error message
- ✅ All operations logged with colored output

## 📚 Related Formulas

- `prerequisites.md` - System requirements
- `features.md` - Core features documentation
- `testing_checklist.md` - Quality assurance steps

---

**Created:** 2026-02-28
**Stage:** 4_Formula (Canonical Recipe)
**Type:** Automation Workflow
