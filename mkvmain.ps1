# Include required files
param (
    [CmdletBinding()]
    $videosPath = $PSScriptRoot
 )

try {
    . ("$PSScriptRoot\main-lib.ps1")
    . ("$PSScriptRoot\itunes-movies.ps1")
    . ("$PSScriptRoot\itunes-tv.ps1")
    . ("$PSScriptRoot\crunchyroll.ps1")
}
catch {
    Write-Host $Error[0] -ForegroundColor Red
    Read-Host -Prompt "Press the 'Enter' to exit" 
}
# Setup Variables
$mkvProgPath = "C:\Program Files\MKVToolNix\mkvmerge.exe"
$mkvEditPath = "C:\Program Files\MKVToolNix\mkvpropedit.exe"
$subtitleEditPath = "C:\Program Files\Subtitle Edit\SubtitleEdit.exe"

function Read-TargetDirectory {
    param(
        $videosPath
    )
    $videoExtensions = @("*.mp4")
    $queue = Get-ChildItem -Path $videosPath -Include $videoExtensions -Recurse
    return (, $queue)
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
        $subtitleType = $null
    }

}

Start-Conversion $videosPath