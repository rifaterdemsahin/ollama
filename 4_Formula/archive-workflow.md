# 📐 Formula: Archive Workflow with Date-Based Organization

## 🎯 Purpose

Automatically save clipboard content to a date-organized archive folder with AI-generated titles using Ollama's llama3 model.

## 🔣 Architecture

```
Clipboard → PowerShell Script → Ollama API → Title Generation
                ↓
    Date Folder Structure Creation (YYYY/MM/DD)
                ↓
    Markdown File with Metadata
                ↓
    F:\secondbrain_v4\secondbrain\secondbrain\4_Archieve\2026\02\28\
```

## 🛠 The Recipe

### Step 1: Date Path Construction

```powershell
$year = Get-Date -Format "yyyy"   # 2026
$month = Get-Date -Format "MM"    # 02
$day = Get-Date -Format "dd"      # 28

$archivePath = Join-Path $archiveBasePath "$year\$month\$day"
# Result: F:\...\4_Archieve\2026\02\28
```

### Step 2: Clipboard Acquisition

```powershell
$clipboardContent = Get-Clipboard -Raw

# Validation
if ([string]::IsNullOrWhiteSpace($clipboardContent)) {
    exit 1
}
```

### Step 3: Directory Auto-Creation

```powershell
if (-not (Test-Path $archivePath)) {
    New-Item -ItemType Directory -Path $archivePath -Force
}
```

### Step 4: Ollama Title Generation

```powershell
$ollamaUrl = "http://localhost:11434/api/generate"

$body = @{
    model = "llama3:latest"
    prompt = "Generate a short, descriptive title (5-8 words maximum)..."
    stream = $false
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri $ollamaUrl -Method Post -Body $body
$title = $response.response.Trim()
```

### Step 5: Filename Sanitization

```powershell
# Remove invalid characters
$filename = $title -replace '[\\/:*?"<>|]', '-' -replace '\s+', '-'

# Add timestamp prefix for uniqueness
$timestamp = Get-Date -Format "HHmmss"
$filename = "$timestamp-$filename.md"

# Example: 071223--Llama-Powered-PowerShell-Archiving-Solution-.md
```

### Step 6: Markdown File Creation

```powershell
$markdownContent = @"
# $title

**Created:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Source:** Clipboard via Ollama Archive
**Archive Date:** $year-$month-$day
**Location:** 4_Archieve/$year/$month/$day/

---

$clipboardContent
"@

$markdownContent | Out-File -FilePath $fullPath -Encoding UTF8
```

## 🧪 Performance Characteristics

### Time Complexity
- **Clipboard Read:** O(1) - instant
- **Path Creation:** O(1) - constant time
- **Ollama API Call:** O(n) - depends on content length
- **File Write:** O(n) - linear with content size

### Expected Performance
- **Small content (< 1KB):** 2-5 seconds
- **Medium content (1-10KB):** 3-8 seconds
- **Large content (> 10KB):** 5-15 seconds

*Primary bottleneck: Ollama inference time*

### Resource Usage
- **Memory:** < 50MB PowerShell process
- **Disk:** Minimal (one file per execution)
- **Network:** Local API call (http://localhost:11434)

## ✨ Usage

### Direct Execution
```powershell
.\save-to-archive.ps1
```

### Stream Deck Integration
```
App: powershell.exe
Arguments: -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\projects\ollama\save-to-archive.ps1"
```

## 🌀 Error Handling

### Fallback Strategy
If Ollama API fails:
```powershell
# Creates file with generic timestamp
$fallbackFilename = "note-$(Get-Date -Format 'HHmmss').md"
```

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| "F: drive not found" | Drive disconnected | Check F: drive availability |
| "model 'llama3.2' not found" | Wrong model name | Use `llama3:latest` |
| Empty clipboard | No content copied | Copy text before running |
| Ollama connection failed | Service not running | Start `ollama serve` |

## 📊 File Structure Example

```
F:\secondbrain_v4\secondbrain\secondbrain\4_Archieve\
├── 2026\
│   ├── 02\
│   │   ├── 28\
│   │   │   ├── 071223--Llama-Powered-PowerShell-Archiving-Solution-.md
│   │   │   ├── 080145-Qdrant-Vector-Database-Setup-Guide.md
│   │   │   └── 091530-Stream-Deck-Automation-Workflow.md
│   │   └── 27\
│   └── 01\
└── archive-log.txt
```

## 🔍 Comparison with Other Methods

| Method | Speed | Organization | AI Titles | Stream Deck |
|--------|-------|--------------|-----------|-------------|
| **Archive Workflow** | ⚡⚡⚡ | 📅 Date-based | ✅ Ollama | ✅ |
| Second Brain Systems | ⚡⚡⚡ | 📁 Manual | ✅ Ollama | ✅ |
| Git Commit Workflow | ⚡⚡ | 🌳 Git history | ✅ Ollama | ❌ |
| Manual Filing | ⚡ | 📂 Custom | ❌ | ❌ |

## 📚 Related Formulas

- `ollama-title-generator-workflow.md` - Git commit variant
- `prerequisites.md` - System requirements
- `features.md` - Core capabilities

## 🧬 Variables Reference

```powershell
# Configuration
$archiveBasePath = "F:\secondbrain_v4\secondbrain\secondbrain\4_Archieve"
$logFile = Join-Path $archiveBasePath "archive-log.txt"

# Dynamic Variables
$year, $month, $day      # Date components
$archivePath             # Full directory path
$clipboardContent        # Raw clipboard data
$title                   # Ollama-generated title
$filename                # Sanitized filename with timestamp
$fullPath                # Complete file path
```

---

**Created:** 2026-02-28
**Stage:** 4_Formula (Canonical Recipe)
**Type:** Archive Automation
**Script:** `save-to-archive.ps1`
**Model:** llama3:latest
**Stream Deck:** Compatible
