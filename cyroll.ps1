# For crunchyroll stuff
$crunchySubs = (".deDE.ass", ".deDE.srt", ".enUS.ass", ".enUS.srt", ".esES.ass",
".esES.srt", ".esLA.ass", ".esLA.srt")
function Test-CrunchyLanguage {
    param (
        $inputFile
    )

    $inputSubtitle = Join-Path $inputFile.DirectoryName  $inputFile.BaseName
    foreach ($subtitle in $crunchySubs){
        $testSubtitle = $inputSubtitle + $subtitle
        if (Test-Path -Path $testSubtitle -PathType Leaf) {
            return $true
        } else {
            return $false
        }
    }
}


