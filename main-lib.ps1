# generic functions
. (".\it.ps1")
. (".\cyroll.ps1")
function Set-SubtitleType {
    param (
        $inputFile
    )
        
    # iTunes movies - Folder with the same name (subs extracted with Tuneskit)
    $itmDIR = $inputFile.DirectoryName + '\\' + $inputFile.BaseName
    # iTunes TV - Same File name - SRT extension (subs extracted with CCextractor)
    $ittvDIR = $inputFile.BaseName
    # Crunchyroll - Same file name - additional enUS (subs extracted with Allavsoft)
    $crunchySub = Test-CrunchyLanguage
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