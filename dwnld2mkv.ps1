﻿# Include required files
param (
    [CmdletBinding()]
    [string]$videosPath = "D:\Prep-For-Transfer\iTunes Movies" #$($PSScriptRoot)
 )

try {
    . (".\main-lib.ps1")
    . (".\it.ps1")
    . (".\itm.ps1")
    . (".\cyroll.ps1")
}
catch {
    Write-Host $Error[0] -ForegroundColor Red
    Read-Host -Prompt "Press the 'Enter' key to exit" 
}
function Start-Conversion {
    param(
        $videosPath
    )
    
    $videoQueue = Read-TargetDirectory $videosPath

    if ($videoQueue.Count -le 0) {
        exit 0
    }

    foreach ($nextVideo in $videoQueue) {
        
        $subTitleType = Set-SubtitleType $nextVideo
        if ($null -ne $subTitleType) {
            $convertARGs = Get-MKVFullArgs $nextVideo $subTitleType
            Invoke-MKVCreator $convertARGs $subTitleType
            Invoke-SessionCleanup $nextVideo $subTitleType
        } else {
            exit(1)
        }
    }

}

Start-Conversion $videosPath