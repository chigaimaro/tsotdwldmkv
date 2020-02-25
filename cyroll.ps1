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
            continue
        }
    }
}


function Set-CrunchLang($current_sub) {
    $fullstring = @()
    $crunchyRollLangPattern = [regex]::new('(?<=\.).+?(?=\.)')
    $pulled_language = $crunchyRollLangPattern.Matches($current_sub)

    $crunchyRollExtPattern = [regex]::new('\.[0-9a-z]+$')
    $pulled_extension = $crunchyRollExtPattern.Matches($current_sub)
    
    if ($pulled_language.Value -eq "esES") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:[Español Spain] Unstyled')}
            ".ass" {$fullstring += ('--track-name', '0:[Español Spain] Styled')}
        }
    } elseif ($pulled_language.Value -eq "esLA") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Español US] Unstyled"')}
            ".ass" {$fullstring += ('--track-name', '0:"[Español US] Styled"')}
        }
    } elseif ($pulled_language.Value -eq "deDE") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Deutsch] Unstyled"')}
            ".ass" {$fullstring += ('--track-name', '0:"[Deutsch] Styled"')}
        }
    } elseif ($pulled_language.Value -eq "enUS") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[English] Unstyled"')}
            ".ass" {$fullstring += ('--track-name', '0:"[English] Styled"')}
        }
    }
    $fullstring += ("--default-track", "0:no")
    $fullstring += $current_sub
    return $fullstring
}