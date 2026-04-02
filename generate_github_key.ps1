$ErrorActionPreference = "Stop"

$email = "alexantony007@gmail.com"
$keyPath = "$HOME\.ssh\id_ed25519"
$pubKeyPath = "$HOME\.ssh\id_ed25519.pub"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "     GitHub SSH Key Generator & Setup     " -ForegroundColor Cyan
Write-Host "==========================================`n" -ForegroundColor Cyan

# 1. Generate SSH Key if it doesn't exist
if (-not (Test-Path $keyPath)) {
    Write-Host "Generating a new ED25519 SSH key for $email..." -ForegroundColor Yellow
    
    # Create .ssh directory if needed
    if (-not (Test-Path "$HOME\.ssh")) {
        New-Item -Path "$HOME\.ssh" -ItemType Directory -Force | Out-Null
    }

    # Generate key without prompting for passphrase (-N "")
    # Note: On Windows, empty quotes logic can be tricky, passing literally "" 
    $proc = Start-Process ssh-keygen -ArgumentList "-t ed25519 -C `"$email`" -f `"$keyPath`" -N `"`"" -NoNewWindow -Wait -PassThru
    
    if ($proc.ExitCode -eq 0) {
        Write-Host "SSH key generated successfully at $keyPath." -ForegroundColor Green
    } else {
        Write-Host "Key generation failed. You may need to run this manually." -ForegroundColor Red
    }
} else {
    Write-Host "You already have an SSH key at $keyPath." -ForegroundColor Green
}

# 2. Add to ssh-agent
Write-Host "Attempting to start ssh-agent..."
try {
    # Check if we can start the service
    $service = Get-Service ssh-agent -ErrorAction SilentlyContinue
    if ($null -ne $service) {
        if ($service.Status -ne "Running") {
            Set-Service ssh-agent -StartupType Manual -ErrorAction SilentlyContinue
            Start-Service ssh-agent -ErrorAction SilentlyContinue
        }
        ssh-add $keyPath | Out-Null
        Write-Host "Added key to SSH agent." -ForegroundColor Green
    }
} catch {
    Write-Host "Note: Could not automatically start the ssh-agent service, but you can still use the key." -ForegroundColor Yellow
}

# 3. Read and copy public key
$pubKey = Get-Content $pubKeyPath

try {
    Set-Clipboard -Value $pubKey
    Write-Host "`nSUCCESS! Your public SSH key has been automatically COPIED to your clipboard (`"Ctrl+V`" to paste)." -ForegroundColor Green
} catch {
    Write-Host "`nCould not automatically copy to clipboard." -ForegroundColor Yellow
}

Write-Host "`n-------------------------------------------------------" 
Write-Host "Here is your public key if the clipboard didn't work:" -ForegroundColor Cyan
Write-Host $pubKey
Write-Host "-------------------------------------------------------`n"

# 4. Change remote to SSH instead of HTTPS
if (Test-Path ".git") {
    Write-Host "Updating Git repository to use SSH instead of HTTPS..."
    try {
        git remote set-url origin git@github.com:alexantony-007/anton.git
        Write-Host "Git remote URL updated to: git@github.com:alexantony-007/anton.git" -ForegroundColor Green
    } catch {
        Write-Host "Warning: Could not update the Git remote URL." -ForegroundColor Yellow
    }
}

# 5. Instructions
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "           NEXT STEPS REQUIRED            " -ForegroundColor Red
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "1. Go to this URL in your web browser:" -ForegroundColor White
Write-Host "   https://github.com/settings/ssh/new" -ForegroundColor Cyan
Write-Host "2. Choose a title (like 'My Windows PC')." -ForegroundColor White
Write-Host "3. PASTE the key into the 'Key' box (it's already on your clipboard!)." -ForegroundColor White
Write-Host "4. Click 'Add SSH key'." -ForegroundColor White
Write-Host "5. Once added to GitHub, run 'push_to_github.ps1' again!" -ForegroundColor White

Write-Host "`nPress any key to close this window..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
