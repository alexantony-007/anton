$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$assetDir = ".\assets\images"
if (-not (Test-Path $assetDir)) {
    New-Item -ItemType Directory -Force -Path $assetDir | Out-Null
}

Write-Host "Downloading Ceramic Coating image..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800&q=80" -OutFile "$assetDir\ceramic_coating.jpg"

Write-Host "Downloading Car Painting image..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://images.unsplash.com/photo-1610647752706-3bb12232b3ab?w=800&q=80" -OutFile "$assetDir\car_painting.jpg"

Write-Host "Downloading Accident Repair image..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "https://images.unsplash.com/photo-1510444322434-2e99f45ebd30?w=800&q=80" -OutFile "$assetDir\accident_repair.jpg"

Write-Host "`nAll 3 high-quality images have been permanently saved to your assets folder!" -ForegroundColor Green
