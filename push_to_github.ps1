$ErrorActionPreference = "Stop"

Write-Host "Setting up Git and pushing to GitHub..." -ForegroundColor Cyan

try {
    # 1. Initialize
    if (-not (Test-Path ".git")) {
        Write-Host "Initializing new Git repository..."
        git init
    }

    # 2. Config
    Write-Host "Setting Git configuration..."
    git config user.name "alexantony-007"
    git config user.email "alexantony007@gmail.com"

    # 3. Add Remote
    $remotes = git remote
    if ($remotes -notcontains "origin") {
        Write-Host "Adding GitHub remote 'origin'..."
        git remote add origin https://github.com/alexantony-007/anton.git
    } else {
        Write-Host "Updating GitHub remote 'origin'..."
        git remote set-url origin https://github.com/alexantony-007/anton.git
    }

    # 4. Add and Commit
    Write-Host "Adding files to commit..."
    git add .
    try {
        git commit -m "Initial launch: Anton Automobile project"
    } catch {
        Write-Host "Nothing new to commit or commit failed (this is fine if you've already committed)." -ForegroundColor Yellow
    }

    # 5. Branch & Push
    Write-Host "Setting branch to 'main'..."
    git branch -M main

    Write-Host "Pushing code to GitHub! Note: You may be prompted to log into GitHub by your browser." -ForegroundColor Magenta
    git push -u origin main
    
    Write-Host "Successfully pushed code to GitHub!" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    Write-Host "Please make sure Git is installed and you have access to the repository." -ForegroundColor Yellow
}

Write-Host "`nPress any key to close this window..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
