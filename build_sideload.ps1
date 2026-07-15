param (
    [string]$WebhookUrl = "",
    [string]$DevKeyPath = ""
)

Write-Host "========================================"
Write-Host " Supplement Tracker Sideload Builder"
Write-Host "========================================"

if ([string]::IsNullOrWhiteSpace($WebhookUrl)) {
    $WebhookUrl = Read-Host "Enter your Google Apps Script Webhook URL"
}

if ([string]::IsNullOrWhiteSpace($DevKeyPath)) {
    $DevKeyPath = Read-Host "Enter the path to your Garmin Developer Key (.der file)"
}

if (!(Test-Path $DevKeyPath)) {
    Write-Host "Developer key not found at $DevKeyPath" -ForegroundColor Red
    exit 1
}

# Update properties.xml
$propertiesPath = ".\resources\settings\properties.xml"
$xml = [xml](Get-Content $propertiesPath)
$property = $xml.properties.property | Where-Object { $_.id -eq 'WebhookUrl' }
if ($property) {
    $property.InnerText = $WebhookUrl
    $xml.Save((Convert-Path $propertiesPath))
    Write-Host "`n[1/2] Updated properties.xml with Webhook URL." -ForegroundColor Green
}

# Run build
Write-Host "[2/2] Building Garmin App for Venu 3..."
monkeyc -d venu3 -f monkey.jungle -y $DevKeyPath -o GarminSupplementTracker.prg

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nBuild Successful!" -ForegroundColor Green
    Write-Host "You can now copy GarminSupplementTracker.prg to your watch's GARMIN/APPS folder." -ForegroundColor Cyan
} else {
    Write-Host "`nBuild failed." -ForegroundColor Red
}
