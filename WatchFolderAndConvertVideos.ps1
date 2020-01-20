### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "D:\source\"
    $watcher.Filter = "*.*"
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true
    
### SET OUTPUT FOLDER
    $output = "D:\destination\"

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = { $path = $Event.SourceEventArgs.FullPath
                $changeType = $Event.SourceEventArgs.ChangeType
                $logline = "$(Get-Date), $changeType, $path"
                Add-content "D:\Handbrake\log.txt" -value $logline

                $fileName =  (Get-Item $path).BaseName + ".mp4"

                Write-Verbose $fileName -Verbose
                $outputPath = Join-Path $output $fileName

                Write-Verbose $outputPath -Verbose

                Iex "D:\Handbrake\HandBrakeCLI.exe --preset-import-file D:\Handbrake\vizRT.json -Z `"15Q HD 25 FPS`" -i $path -o $outputPath"
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
    
    #Register-ObjectEvent $watcher "Changed" -Action $action
    #Register-ObjectEvent $watcher "Deleted" -Action $action
    #Register-ObjectEvent $watcher "Renamed" -Action $action

    while ($true) {sleep 5}
