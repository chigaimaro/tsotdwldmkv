# for Itunes Movies
function Test-iTunesTVSubs {
    param (
        $inputFile
    )
    # iTunes TV - Same File name - SRT extension (subs extracted with CCextractor)
    $ittvDIR = $inputFile.BaseName + ".srt"
    return Test-SubPath $ittvDIR
}


function Test-iTunesMovieSubs {
    param (
        $inputFile
    )
    # iTunes movies - Folder with the same name (subs extracted with Tuneskit)
    $itmDIR = $inputFile.DirectoryName + '\\' + $inputFile.BaseName
    $subTitleQueue = Test-SubPath $itmDIR
    foreach ($subtitle in $subTitleQueue) {
        if (Test-SubPath $subtitle) {
            return $true
        } else {
            return $false
        }
    }
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

function Read-subDirectory {
    param(
        $subtitleDir
    )
    $subTitleExtension = @("*.srt")
    $queue = Get-ChildItem -Path $subtitleDir -Include $subTitleExtensions -Recurse
    return (, $queue)
}