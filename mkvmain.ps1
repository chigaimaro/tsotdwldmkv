# Include required files
param (
    [CmdletBinding()]
    $videosPath = "D:\test"
 )

try {
    . (".\main-lib.ps1")
    . (".\it.ps1")
    . (".\cyroll.ps1")
}
catch {
    Write-Host $Error[0] -ForegroundColor Red
    Read-Host -Prompt "Press the 'Enter' to exit" 
}
# Setup Variables
$mkvProgPath = "C:\Program Files\MKVToolNix\mkvmerge.exe"
$mkvEditPath = "C:\Program Files\MKVToolNix\mkvpropedit.exe"
$subtitleEditPath = "C:\Program Files\Subtitle Edit\SubtitleEdit.exe"




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
    }

}

Start-Conversion $videosPath