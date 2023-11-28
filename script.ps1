# Define the directory to monitor
$directoryToMonitor = Get-Location

# Create a FileSystemWatcher object
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $directoryToMonitor
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $false  # Set to $true to monitor subdirectories as well

# Define the event action when a new file is created
$action = {
    $file = $Event.SourceEventArgs.FullPath
    Write-Host "Printing $file"
	Start-Sleep -Milliseconds 100
	Start-Process -FilePath $file -Verb Print
}

# Register the event handler
Register-ObjectEvent -InputObject $watcher -EventName Created -Action $action -SourceIdentifier "FileCreated"

try {
    # Start monitoring
    $watcher.EnableRaisingEvents = $true

    # Continuously poll for changes every 1 second
    while ($true) {
        $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::Created, 1000)
    }
}
finally {
    $watcher.EnableRaisingEvents = $false
    Unregister-Event -SourceIdentifier "FileCreated"
    $watcher.Dispose()
}
