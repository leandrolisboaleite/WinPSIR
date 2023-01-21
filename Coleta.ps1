$banner = @"
*********************************************************
*               Windows Powershell coleta               *
*********************************************************
"@

Write-Host $banner -ForegroundColor Cyan
Start-Sleep -Seconds 5
$commands = @(
    @{Title = "IP Configuration"; Command = "ipconfig /all"},
    @{Title = "Users"; Command = "net user"},
    @{Title = "Groups"; Command = "localgroup"},
    @{Title = "Tasks"; Command = "tasklist /svc"},
    @{Title = "Services"; Command = "net start"},
    @{Title = "Registery Control"; Command = "reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"},
    @{Title = "Active TCP & UDP ports"; Command = "netstat -ano"},
    @{Title = "File Sharing"; Command = "net view"},
    @{Title = "Firewall Config"; Command = "netsh firewall show config"},
    @{Title = "Sessions with other Systems"; Command = "net use"},
    @{Title = "Open Sessions"; Command = "net session"},
    @{Title = "Log Entries"; Command = "wevtutil qe security"},
    @{Title = "Files"; Command = "Get-ChildItem -Recurse -File -Include '*.exe' -ErrorAction SilentlyContinue | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-10)} | Select-Object Extension, Name, LastWriteTime"}
)

$outputFile = "C:\Coleta.txt"

$confirmation = $null
$timer = 0
while (-not $confirmation) {
    if ($timer -eq 30) {
        $confirmation = "Y"
    }
    else {
        $confirmation = Read-Host "Do you want to create the file 'Coleta.txt' at the specified location $outputFile? (Y/N)" -Timeout 30
    }
    $timer++
}

if ($confirmation -eq "Y") {
    if (!(Test-Path $outputFile)) {
        New-Item -ItemType file -Path $outputFile
    }
    foreach ($command in $commands) {
        Write-Host "Running command: $($command.Title)" -ForegroundColor Green
        Add-Content $outputFile ("`n`n" + $command.Title + "`n" + "-"*20)
        Add-Content $outputFile (Invoke-Expression $command.Command)
    }
}
elseif ($confirmation -eq "N") {
    $outputFile = Read-Host "Please enter the specific path where you want to create the file (e.g. C:\temp\Coleta.txt)"
    if (!(Test-Path $outputFile)) {
        New-Item -ItemType file -Path $outputFile
    }
    foreach ($command in $commands) {
        Write-Host "Running command: $($command.Title)" -ForegroundColor Green
        Add-Content $outputFile ("`n`n" + $command.Title + "`n" + "-"*20)
        Add-Content $outputFile (Invoke-Expression $command.Command)
    }
}