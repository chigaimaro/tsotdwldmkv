# For crunchyroll stuff
$Global:crunchySubs = ("arME.ass", "arME.srt", ".deDE.ass", ".deDE.srt", "frFR.srt",
 "frFR.ass", ".enUS.ass", ".enUS.srt", ".esES.ass", ".esES.srt", ".esLA.ass",
 ".esLA.srt",  "itIT.ass", "itIT.srt", "ptBR.ass", "ptBR.srt", "ruRU.ass", "ruRU.srt")

function Test-AllavCRSubs {
    param (
        $inputFile
    )

    $inputVideo = Join-Path $inputFile.DirectoryName  $inputFile.BaseName
    foreach ($subtitle in $crunchySubs){
        $testSubtitle = $inputVideo + $subtitle
        if (Test-Path -Path $testSubtitle -PathType Leaf) {
            ($current_sub)
        } else {
            continue
        }
    }
}

function Get-AllavCRArgs {
    param (
        $inputFile
    )
    $mkvSubs = @()
    foreach ($subtitle in $crunchySubs) {
        $current_sub = $(Join-Path $inputFile.DirectoryName  $inputFile.BaseName) + $subtitle
        if (Test-Path -Path $current_sub -PathType Leaf) {
            $mkvSubs += Set-AllavCRLang $current_sub
        }
    }
    return $mkvSubs
}

function Set-AllavCRLang($current_sub) {
    $fullstring = @()
    $crunchyRollLangPattern = [regex]::new('(?<=\.).+?(?=\.)')
    $pulled_language = $crunchyRollLangPattern.Matches($current_sub)

    $crunchyRollExtPattern = [regex]::new('\.[0-9a-z]+$')
    $pulled_extension = $crunchyRollExtPattern.Matches($current_sub)
    
    if ($pulled_language.Value -eq "esES") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:[Español Spain] Unstyled'); Break}
            ".ass" {$fullstring += ('--track-name', '0:[Español Spain] Styled'); Break }
        }
    } elseif ($pulled_language.Value -eq "esLA") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Español US] Unstyled"'); Break }
            ".ass" {$fullstring += ('--track-name', '0:"[Español US] Styled"'); Break }
        }
    } elseif ($pulled_language.Value -eq "deDE") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Deutsch] Unstyled"'); Break }
            ".ass" {$fullstring += ('--track-name', '0:"[Deutsch] Styled"'); Break }
        }
    } elseif ($pulled_language.Value -eq "enUS") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[English] Unstyled"'); Break }
            ".ass" {$fullstring += ('--track-name', '0:"[English] Styled"'); Break }
        }
    } elseif ($pulled_language.Value -eq "ptBR") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Brazilian Portguese] Unstyled"'); Break }
            ".ass" {$fullstring += ('--track-name', '0:"[Brazilian Portguese] Styled"'); Break }
        }
    } elseif ($pulled_language.Value -eq "deDE") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Deutsch] Unstyled"'); Break }
            ".ass" {$fullstring += ('--track-name', '0:"[Deutsch] Styled"'); Break }
        }
    } elseif ($pulled_language.Value -eq "frFR") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Français] Unstyled"'); Break }
            ".ass" {$fullstring += ('--track-name', '0:"[Français] Styled"'); Break }
        }
    } elseif ($pulled_language.Value -eq "itIT") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Italian] Unstyled"'); Break }
            ".ass" {$fullstring += ('--track-name', '0:"[Italian] Styled"'); Break }
        }
    } elseif ($pulled_language.Value -eq "arME") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Arabic] Unstyled"'); Break }
            ".ass" {$fullstring += ('--track-name', '0:"[Arabic] Styled"'); Break }
        }
    } elseif ($pulled_language.Value -eq "ruRU") {
        switch ($pulled_extension.value) {
            ".srt" {$fullstring += ('--track-name', '0:"[Russian] Unstyled"'); Break }
            ".ass" {$fullstring += ('--track-name', '0:"[Russian] Styled"'); Break }
        }
    } 
    $fullstring += ("--default-track", "0:no")
    $fullstring += $current_sub
    return $fullstring
}

function Remove-AllavCRItems($video) {
    $fileSet = $($video.BaseName) + ".*"
    $removed_files = Get-ChildItem -Path $video.DirectoryName -Filter $fileSet
    foreach ($file in $removed_files) {
        if ($file.Extension -ne ".mkv") {
            Remove-Item $file.FullName
        }
    }
}


function Set-JapaneseTrack {
    param (
        $inputMKV
    )
    $mkvEditPath = "C:\Program Files\MKVToolNix\mkvpropedit.exe"
    $mkvEditArgs = @("$inputMKV", "--edit", "track:2", "--set", "language=jpn", "--set", 'name="JPN Stereo 2.0"')
    & $mkvEditPath $mkvEditArgs
}