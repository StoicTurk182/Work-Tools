<#
.SYNOPSIS
    Run PSTools executables with common arguments
.DESCRIPTION
    Lists all .exe files in D:\Tools\PSTools and allows running them with pre-defined or custom arguments
#>

$psToolsPath = "D:\Tools\PSTools"

function Show-PsToolsMenu {
    param (
        [array]$tools
    )
    
    Clear-Host
    Write-Host "`n=== PSTools Launcher ===" -ForegroundColor Cyan
    Write-Host "Path: $psToolsPath`n"
    
    for ($i = 0; $i -lt $tools.Count; $i++) {
        Write-Host "$($i+1). $($tools[$i].Name)"
    }
    
    Write-Host "`nQ. Quit`n"
}

function Get-CommonArguments {
    param (
        [string]$toolName
    )
    
    switch ($toolName.ToLower()) {
        "psexec.exe" {
            return @(
                "-i \\remotePC cmd.exe`t(Run command interactively)",
                "-s \\server -u domain\user -p password notepad.exe`t(Run as system account)",
                "-d \\computer -c C:\tools\program.exe`t(Don't wait, copy file)"
            )
        }
        "pskill.exe" {
            return @(
                "processname`t(Kill by process name)",
                "/t processname`t(Kill process tree)",
                "-t 1234`t(Kill by PID)"
            )
        }
        "pslist.exe" {
            return @(
                "`t(List all processes)",
                "-t`t(Show process tree)",
                "explorer`t(Show specific process)"
            )
        }
        default {
            return @("`t(Run without arguments)")
        }
    }
}

# Main execution
try {
    # Get all PSTools executables
    $tools = Get-ChildItem -Path $psToolsPath -Filter "*.exe" | Sort-Object Name
    
    if (-not $tools) {
        Write-Host "No executables found in $psToolsPath" -ForegroundColor Red
        exit
    }

    do {
        Show-PsToolsMenu -tools $tools
        
        $selection = Read-Host "Select a tool (1-$($tools.Count)) or Q to quit"
        if ($selection -in ('Q','q')) { exit }
        
        if (-not ($selection -match '^\d+$') -or [int]$selection -lt 1 -or [int]$selection -gt $tools.Count) {
            Write-Host "Invalid selection" -ForegroundColor Red
            Start-Sleep -Seconds 1
            continue
        }
        
        $selectedTool = $tools[[int]$selection-1]
        $commonArgs = Get-CommonArguments -toolName $selectedTool.Name
        
        # Show common arguments menu
        Clear-Host
        Write-Host "`n=== $($selectedTool.Name) ===" -ForegroundColor Cyan
        Write-Host "`nCommon arguments patterns:`n"
        
        for ($i = 0; $i -lt $commonArgs.Count; $i++) {
            Write-Host "$($i+1). $($commonArgs[$i])"
        }
        
        Write-Host "`nC. Enter custom arguments"
        Write-Host "B. Back to main menu`n"
        
        $argChoice = Read-Host "Select argument pattern (1-$($commonArgs.Count)) or C/B"
        
        if ($argChoice -in ('B','b')) { continue }
        
        $arguments = ""
        if ($argChoice -in ('C','c')) {
            $arguments = Read-Host "Enter custom arguments"
        }
        elseif ($argChoice -match '^\d+$' -and [int]$argChoice -le $commonArgs.Count) {
            $arguments = ($commonArgs[[int]$argChoice-1] -split "`t")[0]
        }
        
        # Execute the command
        Write-Host "`nExecuting: $($selectedTool.Name) $arguments" -ForegroundColor Yellow
        $processArgs = @{
            FilePath = $selectedTool.FullName
            NoNewWindow = $true
            Wait = $true
        }
        
        if ($arguments) {
            $processArgs['ArgumentList'] = $arguments -split ' '
        }
        
        Start-Process @processArgs
        
        Write-Host "`nOperation completed. Press any key to continue..."
        [void][System.Console]::ReadKey($true)
        
    } while ($true)
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}