# PowerShell script to get Ollama title from clipboard and commit
# Usage: Run this script, it will read clipboard, get a title from Ollama, create .md file, and push to git

# Get clipboard content
$clipboardContent = Get-Clipboard -Raw

if ([string]::IsNullOrWhiteSpace($clipboardContent)) {
    Write-Host "❌ Clipboard is empty!" -ForegroundColor Red
    exit 1
}

Write-Host "📋 Clipboard content (first 100 chars): $($clipboardContent.Substring(0, [Math]::Min(100, $clipboardContent.Length)))..." -ForegroundColor Cyan

# Prepare Ollama API request
$ollamaUrl = "http://localhost:11434/api/generate"
$prompt = "Generate a short, descriptive title (5-8 words maximum) for the following text. Respond with ONLY the title, no explanation:`n`n$clipboardContent"

$body = @{
    model = "llama3.2"
    prompt = $prompt
    stream = $false
} | ConvertTo-Json

Write-Host "🤖 Calling Ollama to generate title..." -ForegroundColor Yellow

# Call Ollama API
try {
    $response = Invoke-RestMethod -Uri $ollamaUrl -Method Post -Body $body -ContentType "application/json"
    $title = $response.response.Trim()

    # Clean title for filename (remove special characters, limit length)
    $filename = $title -replace '[\\/:*?"<>|]', '-' -replace '\s+', '-'
    $filename = $filename.Substring(0, [Math]::Min(60, $filename.Length))
    $filename = "$filename.md"

    Write-Host "✨ Generated title: $title" -ForegroundColor Green
    Write-Host "📄 Filename: $filename" -ForegroundColor Green

    # Create the markdown file with clipboard content
    $clipboardContent | Out-File -FilePath $filename -Encoding UTF8
    Write-Host "✅ Created file: $filename" -ForegroundColor Green

    # Git operations
    Write-Host "🔧 Adding to git..." -ForegroundColor Yellow
    git add $filename

    Write-Host "📝 Committing..." -ForegroundColor Yellow
    git commit -m "Add $title"

    Write-Host "🚀 Pushing to remote..." -ForegroundColor Yellow
    git push

    Write-Host "✅ Done! File created, committed, and pushed." -ForegroundColor Green

} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
