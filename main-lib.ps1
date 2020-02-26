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

function Get-FullArgs {
    param (
        $inputFile,
        $subTitleType
    )
    $current_mkv = $(Join-Path $inputFile.DirectoryName  $inputFile.BaseName) + ".mkv"
    $mkvArgList = @('-o', $current_mkv, $inputFile.FullName)
    if ($subTitleType -eq "itms") {
        $mkvArgList += Get-IttvSubs $inputFile
    } elseif ($subTitleType -eq "ittv") {
        $mkvArgList += Get-ItMSubs $inputFile
    } elseif ($subTitleType -eq "chry") {
        $mkvArgList += Get-CrunchySubTitles $inputfile
    }
    return $mkvArgList
}