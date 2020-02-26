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
    Read-Host -Prompt "Press the 'Enter' key to exit" 
}
# Setup Variables
$mkvProgPath = "C:\Program Files\MKVToolNix\mkvmerge.exe"
$mkvEditPath = "C:\Program Files\MKVToolNix\mkvpropedit.exe"




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
       $convertARGs = Get-FullArgs $nextVideo $subTitleType
       #TODO
       Invoke-VideoMux $convertARGs
       Invoke-SessionCleanup $nextVideo $subTitleType
       
    }

}

Start-Conversion $videosPath