# 🎮 Stream Deck Setup Guide

## 🎯 Purpose

Configure Stream Deck to trigger the Second Brain clipboard saver with a single button press.

## 📋 Prerequisites

- Stream Deck software installed
- PowerShell script: `save-to-second-brain.ps1`
- Ollama running on `localhost:11434`
- F: drive with `F:\SecondBrain\systems\` folder

## 🛠 Stream Deck Configuration

### Method 1: System > Open (Recommended)

1. **Add Button** in Stream Deck
2. **Action Type:** System > Open
3. **Settings:**
   - **App/File:** `powershell.exe`
   - **Arguments:**
     ```
     -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\projects\ollama\save-to-second-brain.ps1"
     ```
4. **Icon:** Choose a brain or clipboard icon
5. **Title:** "Save Note" or "📋 → 🧠"

### Method 2: System > Website (Alternative)

1. **Add Button** in Stream Deck
2. **Action Type:** System > Website
3. **URL:**
   ```
   file:///C:/projects/ollama/streamdeck-launcher.bat
   ```
4. Create `streamdeck-launcher.bat`:
   ```batch
   @echo off
   powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\projects\ollama\save-to-second-brain.ps1"
   ```

### Method 3: Multi-Action Button (Advanced)

1. **Add Multi-Action Button**
2. **Step 1:** Copy to clipboard (if needed)
3. **Step 2:** System > Open
   - App: `powershell.exe`
   - Arguments: `-ExecutionPolicy Bypass -File "C:\projects\ollama\save-to-second-brain.ps1"`
4. **Step 3:** Show notification (optional)

## 🧪 Testing

### Quick Test

1. Copy some text to clipboard
2. Press your Stream Deck button
3. Check `F:\SecondBrain\systems\` for new file
4. Review `F:\SecondBrain\systems\save-log.txt` for logs

### Test Content Example

```
Ollama is a local AI model runner that supports llama3.2 and other models.
It provides REST API endpoints for generation and embeddings.
Perfect for offline AI workflows.
```

**Expected Result:**
- File created: `F:\SecondBrain\systems\20260228-143022-Ollama-Local-AI-Model-Runner.md`
- Log entry in `save-log.txt`

## 🔧 Troubleshooting

### Button Doesn't Work

**Check Execution Policy:**
```powershell
Get-ExecutionPolicy
```
If it's `Restricted`, run as Admin:
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### F: Drive Not Found

Update `$secondBrainPath` in script:
```powershell
$secondBrainPath = "C:\SecondBrain\systems"  # Use C: instead
```

### Ollama Not Running

Start Ollama before using:
```bash
ollama serve
```

### No Visual Feedback

Edit script to add notification:
```powershell
# Add at end of script
[System.Windows.Forms.MessageBox]::Show("Note saved to Second Brain!", "Success")
```

## 🌀 Advanced Features

### Custom Categories

Create multiple buttons for different folders:

**Button 1: Systems**
```powershell
$secondBrainPath = "F:\SecondBrain\systems"
```

**Button 2: Ideas**
```powershell
$secondBrainPath = "F:\SecondBrain\ideas"
```

**Button 3: References**
```powershell
$secondBrainPath = "F:\SecondBrain\references"
```

### Auto-Tag Support

Modify script to detect tags in clipboard:
```powershell
if ($clipboardContent -match '#(\w+)') {
    $tag = $matches[1]
    $secondBrainPath = "F:\SecondBrain\tags\$tag"
}
```

## 📚 Related Files

- `save-to-second-brain.ps1` - Main script
- `get-title-and-commit.ps1` - Git workflow variant
- `4_Formula/ollama-title-generator-workflow.md` - Original formula

---

**Created:** 2026-02-28
**Stream Deck Version:** Any
**PowerShell Version:** 5.1+
