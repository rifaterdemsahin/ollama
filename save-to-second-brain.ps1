# PowerShell script to save clipboard notes to Second Brain (F: drive)
# Stream Deck compatible - saves with Ollama-generated title
# Usage: Trigger from Stream Deck or run directly

# Configuration
$secondBrainPath = "F:\SecondBrain\systems"
$logFile = "F:\SecondBrain\systems\save-log.txt"

# Function to log messages
function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append -Encoding UTF8
}

# Get clipboard content
$clipboardContent = Get-Clipboard -Raw

if ([string]::IsNullOrWhiteSpace($clipboardContent)) {
    Write-Host "❌ Clipboard is empty!" -ForegroundColor Red
    Write-Log "ERROR: Clipboard was empty"
    exit 1
}

Write-Host "📋 Clipboard content captured ($(($clipboardContent -split '\n').Count) lines)" -ForegroundColor Cyan
Write-Log "Clipboard content captured: $($clipboardContent.Length) characters"

# Check if F: drive exists
if (-not (Test-Path "F:\")) {
    Write-Host "❌ F: drive not found!" -ForegroundColor Red
    Write-Log "ERROR: F: drive not accessible"
    exit 1
}

# Create Second Brain directory structure if it doesn't exist
if (-not (Test-Path $secondBrainPath)) {
    Write-Host "🔧 Creating directory: $secondBrainPath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $secondBrainPath -Force | Out-Null
    Write-Log "Created directory: $secondBrainPath"
}

# Prepare Ollama API request
$ollamaUrl = "http://localhost:11434/api/generate"
$prompt = "Generate a short, descriptive title (5-8 words maximum) for the following text. Respond with ONLY the title, no explanation:`n`n$clipboardContent"

$body = @{
    model = "llama3.2"
    prompt = $prompt
    stream = $false
} | ConvertTo-Json

Write-Host "🤖 Calling Ollama to generate title..." -ForegroundColor Yellow
Write-Log "Calling Ollama API for title generation"

# Call Ollama API
try {
    $response = Invoke-RestMethod -Uri $ollamaUrl -Method Post -Body $body -ContentType "application/json"
    $title = $response.response.Trim()

    # Clean title for filename (remove special characters, limit length)
    $filename = $title -replace '[\\/:*?"<>|]', '-' -replace '\s+', '-'
    $filename = $filename.Substring(0, [Math]::Min(60, $filename.Length))

    # Add timestamp to make filename unique
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $filename = "$timestamp-$filename.md"

    $fullPath = Join-Path $secondBrainPath $filename

    Write-Host "✨ Generated title: $title" -ForegroundColor Green
    Write-Host "📄 Filename: $filename" -ForegroundColor Green
    Write-Host "📁 Full path: $fullPath" -ForegroundColor Cyan
    Write-Log "Generated title: $title | Filename: $filename"

    # Create markdown file with metadata header
    $markdownContent = @"
# $title

**Created:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Source:** Clipboard via Stream Deck
**Location:** systems/

---

$clipboardContent
"@

    # Save to Second Brain
    $markdownContent | Out-File -FilePath $fullPath -Encoding UTF8
    Write-Host "✅ Saved to Second Brain: $fullPath" -ForegroundColor Green
    Write-Log "SUCCESS: File saved to $fullPath"

    # Optional: Open file in default editor
    # Uncomment next line if you want to auto-open the file
    # Start-Process $fullPath

    Write-Host "`n🎉 Done! Note saved to Second Brain." -ForegroundColor Green
    Write-Host "📍 Location: $fullPath" -ForegroundColor Cyan

} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    Write-Log "ERROR: $($_.Exception.Message)"

    # Fallback: Save with generic timestamp if Ollama fails
    $fallbackFilename = "note-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
    $fallbackPath = Join-Path $secondBrainPath $fallbackFilename
    $clipboardContent | Out-File -FilePath $fallbackPath -Encoding UTF8
    Write-Host "⚠️  Saved with generic filename: $fallbackPath" -ForegroundColor Yellow
    Write-Log "FALLBACK: Saved as $fallbackFilename due to error"

    exit 1
}
