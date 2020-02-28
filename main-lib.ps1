# generic functions
. (".\it.ps1")
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

function Set-OutputMKV {
    param (
        $inputFile
    )
}

function Read-TargetDirectory {
    param(
        $videosPath
    )
    $videoExtensions = @("*.mp4")
    $queue = Get-ChildItem -Path $videosPath -Include $videoExtensions -Recurse
    return (, $queue)
}

function Get-MKVFullArgs {
    param (
        $inputFile,
        $subTitleType
    )
    $current_mkv = $(Join-Path $inputFile.DirectoryName  $inputFile.BaseName) + ".mkv"
    $mkvArgList = @('-o', $current_mkv, $inputFile.FullName)
    if ($subTitleType -eq "itms") {
        # TODO
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
        "chry" { Remove-CrunchyStuff $inputVideo; Break}
        "itms" {  }
        "ittv" {  Remove-ITVStuff $inputVideo; Break}
        Default {}
    }
}