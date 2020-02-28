# generic functions
. (".\it.ps1")
. (".\itm.ps1")
. (".\cyroll.ps1")
function Set-SubtitleType {
    param (
        $inputFile
    )
        
    # iTunes movies - Folder with the same name (subs extracted with Tuneskit)
    if (Test-iTunesMovieSubs $inputFile){
        return "itms"
    }
    # iTunes TV - Same File name - SRT extension (subs extracted with CCextractor)
    elseif (Test-iTunesTVSubs $inputFile) {
        return "ittv"
    }
    # Crunchyroll - Same file name - additional enUS (subs extracted with Allavsoft)
    elseif (Test-CrunchyLanguage $inputFile) {
        return "chry"
    }
}

function Read-TargetDirectory {
    param(
        $videosPath
    )
    $videoExtensions = @("*.mp4")
    $queue = Get-ChildItem -Path $videosPath -Include $videoExtensions -Recurse
    return (, $queue)
}

function Test-SubPath {
    param (
        $inputPath
    )
    if ( $(Try { Test-Path -Path $inputPath.trim() -PathType Leaf } Catch { $false }) ) {
        return $true
      }
     Else {
        return $false
      }
}

function Get-MKVFullArgs {
    param (
        $inputFile,
        $subTitleType
    )
    $current_mkv = $(Join-Path $inputFile.DirectoryName  $inputFile.BaseName) + ".mkv"
    $mkvArgList = @('-o', $current_mkv, $inputFile.FullName)
    if ($subTitleType -eq "itms") {
        $mkvArgList += Get-GetITMArgs $inputFile
    } elseif ($subTitleType -eq "ittv") {
        $mkvArgList += Get-IttvArgs $inputFile
    } elseif ($subTitleType -eq "chry") {
        $mkvArgList += Get-CrunchyArgs $inputfile
    }
    return $mkvArgList
}

function Invoke-MKVCreator {
    param (
        $mkvArgList,
        $subTitleType

    )
    $mkvProgPath = "C:\Program Files\MKVToolNix\mkvmerge.exe"
    & $mkvProgPath $mkvArgList
    if ($subTitleType -eq "chry") {
        Set-JapaneseTrack $mkvArgList[1]
    }
}

function Invoke-SessionCleanup {
    param (
        $inputVideo,
        $subTitleType
    )

    switch ($subTitleType) {
        "chry" { Remove-CrunchyStuff $inputVideo; Break }
        "itms" { Remove-ITMStuff $inputVideo; Break }
        "ittv" { Remove-ITVStuff $inputVideo; Break } 
        Default {}
    }
}