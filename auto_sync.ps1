$folder = $PSScriptRoot
$watcher = New-Object IO.FileSystemWatcher $folder, '*.*' -Property @{
    IncludeSubdirectories = $true
    EnableRaisingEvents   = $true
}

# Ignore the .git folder so it doesn't enter an infinite commit loop!
$action = {
    $path = $Event.SourceEventArgs.FullPath
    
    # Don't trigger on git's internal changes
    if ($path -match '\\.git\\') { return }
    
    $changeType = $Event.SourceEventArgs.ChangeType
    Write-Host "`n[$([datetime]::Now.ToLongTimeString())] Detected $changeType: $path"
    Write-Host "Syncing to GitHub..."
    
    # Unregister events temporarily to debounce and avoid loops during git operations
    Unregister-Event -SourceIdentifier FileChanged -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier FileCreated -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier FileDeleted -ErrorAction SilentlyContinue
    Unregister-Event -SourceIdentifier FileRenamed -ErrorAction SilentlyContinue
    
    # Sleep to allow file locks to release
    Start-Sleep -Seconds 1
    
    try {
        git add .
        git commit -m "Auto-sync: file changes detected"
        git push origin main
        Write-Host "Successfully synced to GitHub." -ForegroundColor Green
    } catch {
        Write-Host "Failed to sync to GitHub. Check if initial commit is set up." -ForegroundColor Red
    }
    
    # Re-register events
    Register-ObjectEvent $watcher "Changed" -SourceIdentifier FileChanged -Action $action | Out-Null
    Register-ObjectEvent $watcher "Created" -SourceIdentifier FileCreated -Action $action | Out-Null
    Register-ObjectEvent $watcher "Deleted" -SourceIdentifier FileDeleted -Action $action | Out-Null
    Register-ObjectEvent $watcher "Renamed" -SourceIdentifier FileRenamed -Action $action | Out-Null
}

Register-ObjectEvent $watcher "Changed" -SourceIdentifier FileChanged -Action $action | Out-Null
Register-ObjectEvent $watcher "Created" -SourceIdentifier FileCreated -Action $action | Out-Null
Register-ObjectEvent $watcher "Deleted" -SourceIdentifier FileDeleted -Action $action | Out-Null
Register-ObjectEvent $watcher "Renamed" -SourceIdentifier FileRenamed -Action $action | Out-Null

Write-Host "Watching for file changes in $folder" -ForegroundColor Cyan
Write-Host "The website will automatically commit and push to GitHub when you save files."
Write-Host "Press Ctrl+C to stop auto-syncing." -ForegroundColor Yellow

while ($true) {
    Start-Sleep -Seconds 1
}
