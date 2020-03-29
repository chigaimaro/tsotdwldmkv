# for Itunes Movies
function Test-CCextractSubs {
    param (
        $inputFile
    )
    # iTunes TV - Same File name - SRT extension (subs extracted with CCextractor)
    $ittvDIR = $(Join-Path $inputFile.DirectoryName  $inputFile.BaseName) + ".srt"
    return Test-SubPath $ittvDIR
}

function Get-CCeArgs {
    param(
        $inputFile
    )
    $fullstring = @("--language", "0:eng", "--track-name", '0:"[US Closed Captions] Unstyled"')
    $fullstring += ("--default-track", "0:no")
    $fullstring += $(Join-Path $inputFile.DirectoryName  $inputFile.BaseName) + ".srt"

    return $fullstring
}

function Remove-CCeItems {
    param (
        $inputVideo
    )
    $fileSet = $($inputVideo.BaseName) + ".*"
    $removed_files = Get-ChildItem -Path $inputVideo.DirectoryName -Filter $fileSet
    foreach ($file in $removed_files) {
        if ($file.Extension -ne ".mkv") {
            Remove-Item $file.FullName
        }
    }
}