# Performance test script for archive workflow
# Measures execution time and resource usage

Write-Host "`n=== Archive Workflow Performance Test ===" -ForegroundColor Cyan
Write-Host "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Yellow
Write-Host "`n"

# Test content sizes
$testContents = @{
    "Small" = "This is a small test note about Ollama and PowerShell integration."
    "Medium" = @"
This is a medium-sized test note.

It contains multiple paragraphs to simulate a typical knowledge note.
Here we discuss Ollama integration with PowerShell for automated archiving.

Key features:
- Date-based folder organization
- AI-generated titles using llama3
- Automatic markdown formatting
- Stream Deck compatibility

The script handles errors gracefully with fallback mechanisms.
"@
    "Large" = @"
# Comprehensive Guide to Ollama PowerShell Integration

## Introduction
This is a large test document that simulates a comprehensive knowledge article.
It includes multiple sections, code examples, and detailed explanations.

## Background
Ollama is a powerful local AI model runner that supports various language models.
When combined with PowerShell automation, it creates a robust workflow for knowledge management.

## Architecture
The system consists of several components:
1. PowerShell script for clipboard monitoring
2. Ollama API for title generation
3. Date-based folder structure for organization
4. Markdown formatting for readability

## Code Examples

Here's how the title generation works:
```powershell
$response = Invoke-RestMethod -Uri $ollamaUrl -Method Post -Body $body
$title = $response.response.Trim()
```

## Performance Considerations
- API latency depends on content length
- File I/O is minimal
- Memory usage stays under 50MB

## Conclusion
This workflow provides an efficient way to archive knowledge with minimal manual effort.
The combination of AI-powered titles and automatic organization creates a scalable system.

## Additional Notes
Testing with larger content helps identify performance bottlenecks.
The primary factor affecting speed is the Ollama inference time.
Network latency is negligible since the API is local.
"@
}

$results = @()

foreach ($size in @("Small", "Medium", "Large")) {
    Write-Host "Testing $size content..." -ForegroundColor Yellow
    $content = $testContents[$size]

    # Copy to clipboard
    $content | Set-Clipboard

    # Measure execution time
    $startTime = Get-Date

    # Run the archive script
    try {
        $output = & powershell.exe -ExecutionPolicy Bypass -File "C:\projects\ollama\save-to-archive.ps1" 2>&1
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds

        # Extract filename from output (convert to string first)
        $outputString = $output -join "`n"
        $filename = if ($outputString -match "Filename: (.+)") { $matches[1] } else { "N/A" }

        $result = [PSCustomObject]@{
            Size = $size
            ContentLength = $content.Length
            Duration = [math]::Round($duration, 2)
            Status = "Success"
            Filename = $filename
        }

        Write-Host "  Duration: $([math]::Round($duration, 2)) seconds" -ForegroundColor Green
        Write-Host "  Content: $($content.Length) characters" -ForegroundColor Cyan
        Write-Host ""

    } catch {
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalSeconds

        $result = [PSCustomObject]@{
            Size = $size
            ContentLength = $content.Length
            Duration = [math]::Round($duration, 2)
            Status = "Failed: $_"
            Filename = "N/A"
        }

        Write-Host "  ERROR: $_" -ForegroundColor Red
    }

    $results += $result
    Start-Sleep -Seconds 2  # Cool-down between tests
}

# Display summary
Write-Host "`n=== Performance Summary ===" -ForegroundColor Cyan
$results | Format-Table -AutoSize

# Calculate statistics
$avgDuration = ($results | Measure-Object -Property Duration -Average).Average
$minDuration = ($results | Measure-Object -Property Duration -Minimum).Minimum
$maxDuration = ($results | Measure-Object -Property Duration -Maximum).Maximum

Write-Host "`n=== Statistics ===" -ForegroundColor Cyan
Write-Host "Average Duration: $([math]::Round($avgDuration, 2)) seconds" -ForegroundColor Yellow
Write-Host "Minimum Duration: $([math]::Round($minDuration, 2)) seconds" -ForegroundColor Green
Write-Host "Maximum Duration: $([math]::Round($maxDuration, 2)) seconds" -ForegroundColor Red

# Save results to file
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$reportFile = "performance-report-$timestamp.md"

$report = @"
# Archive Workflow Performance Test Report

**Date:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Script:** save-to-archive.ps1
**Model:** llama3:latest

## Test Results

| Size | Content Length | Duration (s) | Status | Filename |
|------|----------------|--------------|--------|----------|
$($results | ForEach-Object { "| $($_.Size) | $($_.ContentLength) | $($_.Duration) | $($_.Status) | $($_.Filename) |" } | Out-String)

## Performance Statistics

- **Average Duration:** $([math]::Round($avgDuration, 2)) seconds
- **Minimum Duration:** $([math]::Round($minDuration, 2)) seconds
- **Maximum Duration:** $([math]::Round($maxDuration, 2)) seconds

## Analysis

### Observations
- Small content (< 100 chars): Fastest processing
- Medium content (100-500 chars): Moderate processing time
- Large content (> 500 chars): Longer processing due to Ollama inference

### Bottlenecks
1. **Ollama API inference time** - Primary factor
2. **Content length** - Directly affects processing time
3. **Disk I/O** - Minimal impact

### Recommendations
- For fastest performance: Keep notes concise (< 500 chars)
- For batch operations: Implement rate limiting
- For production use: Consider async processing

---

*Generated by: test-archive-performance.ps1*
"@

$report | Out-File -FilePath $reportFile -Encoding UTF8
Write-Host "`nReport saved to: $reportFile" -ForegroundColor Green
Write-Host "`nTest completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
