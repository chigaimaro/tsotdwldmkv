<#
    .SYNOPSIS
    Creates MKV files from the MP4 and their accompanying subtitle files created with CCextract, Allavsoft, and Tuneskit Subtitle Extractor

    .DESCRIPTION
    Creates MKV files from the MP4 and their accompanying subtitle files created with CCextract, Allavsoft, and Tuneskit Subtitle Extractor
    Takes a path and a subtitle type

    .PARAMETER videoPath
    Specifies the file name.

    .PARAMETER subtitleType
    Specifies the type of subtitles to be added to the MKV.
    Choices are:
    "auto"     basic subtitle type autodetection
    "tnskit"   specifies Subtitles created using TuneskitSubtitle extractor
    "ccex"     specifies Subtitles created using CCextractor
    "allav"    specifies subtitles created Allavsoft Video Downloader (only works with subtitles from Crunchyroll.com)
    
    .INPUTS
    None.

    .OUTPUTS
    video.MKV file with embedded softsubs

    .EXAMPLE
    C:\dwnld2mkv.ps1 -videoPath "D:\Videos\"

    .EXAMPLE
    C:\dwnld2mkv.ps1 -videoPath "D:\Videos\" -subtitleType "tksubs"

    .LINK
    Latest Version: https://github.com/chigaimaro/tsotdwldmkv
#>

param (
    [CmdletBinding()]
    [Parameter(Mandatory=$False)]
    [string]$videosPath = $($PSScriptRoot),
    [Parameter(Mandatory=$False)]
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