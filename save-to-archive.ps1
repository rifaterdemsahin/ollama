# PowerShell script to save clipboard notes to dated Archive folder
# Stream Deck compatible - saves with Ollama-generated title
# Target: F:\secondbrain_v4\secondbrain\secondbrain\4_Archieve\YYYY\MM\DD\

# Configuration
$archiveBasePath = "F:\secondbrain_v4\secondbrain\secondbrain\4_Archieve"
$logFile = Join-Path $archiveBasePath "archive-log.txt"

# Function to log messages
function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    if (Test-Path (Split-Path $logFile -Parent)) {
        "$timestamp - $Message" | Out-File -FilePath $logFile -Append -Encoding UTF8
    }
}

# Get current date components
$year = Get-Date -Format "yyyy"
$month = Get-Date -Format "MM"
$day = Get-Date -Format "dd"

# Build archive path: YYYY/MM/DD
$archivePath = Join-Path $archiveBasePath "$year\$month\$day"

Write-Host "Archive date: $year/$month/$day" -ForegroundColor Cyan
Write-Host "Target path: $archivePath" -ForegroundColor Cyan

# Get clipboard content
$clipboardContent = Get-Clipboard -Raw

if ([string]::IsNullOrWhiteSpace($clipboardContent)) {
    Write-Host "ERROR: Clipboard is empty!" -ForegroundColor Red
    Write-Log "ERROR: Clipboard was empty"
    exit 1
}

$lineCount = ($clipboardContent -split "`n").Count
Write-Host "Clipboard content captured ($lineCount lines)" -ForegroundColor Cyan
Write-Log "Clipboard content captured: $($clipboardContent.Length) characters for $year/$month/$day"

# Check if F: drive exists
if (-not (Test-Path "F:\")) {
    Write-Host "ERROR: F: drive not found!" -ForegroundColor Red
    Write-Log "ERROR: F: drive not accessible"
    exit 1
}

# Create archive directory structure if it doesn't exist
if (-not (Test-Path $archivePath)) {
    Write-Host "Creating directory structure: $archivePath" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $archivePath -Force | Out-Null
    Write-Log "Created directory: $archivePath"
}

# Prepare Ollama API request
$ollamaUrl = "http://localhost:11434/api/generate"
$prompt = "Generate a short, descriptive title (5-8 words maximum) for the following text. Respond with ONLY the title, no explanation:`n`n$clipboardContent"

$body = @{
    model = "llama3:latest"
    prompt = $prompt
    stream = $false
} | ConvertTo-Json

Write-Host "Calling Ollama to generate title..." -ForegroundColor Yellow
Write-Log "Calling Ollama API for title generation"

# Call Ollama API
try {
    $response = Invoke-RestMethod -Uri $ollamaUrl -Method Post -Body $body -ContentType "application/json"
    $title = $response.response.Trim()

    # Clean title for filename (remove special characters, limit length)
    $filename = $title -replace '[\\/:*?"<>|]', '-' -replace '\s+', '-'
    $filename = $filename.Substring(0, [Math]::Min(60, $filename.Length))

    # Add timestamp for uniqueness
    $timestamp = Get-Date -Format "HHmmss"
    $filename = "$timestamp-$filename.md"

    $fullPath = Join-Path $archivePath $filename

    Write-Host "Generated title: $title" -ForegroundColor Green
    Write-Host "Filename: $filename" -ForegroundColor Green
    Write-Host "Full path: $fullPath" -ForegroundColor Cyan
    Write-Log "Generated title: $title | Filename: $filename | Path: $year/$month/$day"

    # Create markdown file with metadata header
    $markdownContent = @"
# $title

**Created:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Source:** Clipboard via Ollama Archive
**Archive Date:** $year-$month-$day
**Location:** 4_Archieve/$year/$month/$day/

---

$clipboardContent
"@

    # Save to Archive
    $markdownContent | Out-File -FilePath $fullPath -Encoding UTF8
    Write-Host "SUCCESS: Saved to Archive: $fullPath" -ForegroundColor Green
    Write-Log "SUCCESS: File saved to $fullPath"

    Write-Host "`nDone! Note archived successfully." -ForegroundColor Green
    Write-Host "Location: $archivePath\$filename" -ForegroundColor Cyan
    Write-Host "Date: $year/$month/$day" -ForegroundColor Cyan

} catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    Write-Log "ERROR: $($_.Exception.Message)"

    # Fallback: Save with generic timestamp if Ollama fails
    $fallbackFilename = "note-$(Get-Date -Format 'HHmmss').md"
    $fallbackPath = Join-Path $archivePath $fallbackFilename

    $fallbackContent = @"
# Note - $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

**Created:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Source:** Clipboard (Ollama unavailable)
**Archive Date:** $year-$month-$day

---

$clipboardContent
"@

    $fallbackContent | Out-File -FilePath $fallbackPath -Encoding UTF8
    Write-Host "WARNING: Saved with generic filename: $fallbackPath" -ForegroundColor Yellow
    Write-Log "FALLBACK: Saved as $fallbackFilename due to error"

    exit 1
}
