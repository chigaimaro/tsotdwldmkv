﻿# Include required files
param (
    [CmdletBinding()]
    [Parameter(Mandatory=$True)]
    [string]$videosPath = $($PSScriptRoot),
    [Parameter(Mandatory=$True)]
    [string]$subtitleType = "auto"
 )

try {
    . (".\main-lib.ps1")
    . (".\ccextract.ps1")
    . (".\tuneskit.ps1")
    . (".\allavsoft.ps1")
}
catch {
    Write-Host $Error[0] -ForegroundColor Red
    Read-Host -Prompt "Press the 'Enter' key to exit" 
}
function Start-Conversion {
    param(
        $videosPath,
        $subtitleType
    )
    
    $videoQueue = Read-TargetDirectory $videosPath

    if ($videoQueue.Count -le 0) {
        exit 0
    }

    foreach ($nextVideo in $videoQueue) {
        if ($subTitleType -eq "auto") {
            $nextSubTitleType = Set-SubtitleType $nextVideo
        } else {
            $nextSubTitleType = $subtitleType
        }
        
        if ($null -ne $subTitleType) {
            $convertARGs = Get-MKVFullArgs $nextVideo $nextSubTitleType
            Invoke-MKVCreator $convertARGs $nextSubTitleType
            Invoke-SessionCleanup $nextVideo $nextSubTitleType
        } else {
            exit(1)
        }
    }

}

Start-Conversion $videosPath $subtitleType