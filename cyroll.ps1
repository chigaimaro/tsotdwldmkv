# For crunchyroll stuff
$Global:crunchySubs = (".deDE.ass", ".deDE.srt", ".enUS.ass", ".enUS.srt", ".esES.ass",
".esES.srt", ".esLA.ass", ".esLA.srt")
function Test-CrunchyLanguage {
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

function Get-CrunchySubTitles {
    param (
        $inputFile
    )
    $mkvSubs = @()
    foreach ($subtitle in $crunchySubs) {
        $current_sub = $(Join-Path $inputFile.DirectoryName  $inputFile.BaseName) + $subtitle
        if (Test-Path -Path $current_sub -PathType Leaf) {
            $mkvSubs += Set-CrunchLang $current_sub
        }
    }
    return $mkvSubs
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

function Remove-CrunchyStuff($video) {
    $newSet = $video.BaseName
    $newSet = $newSet + ".*"
    $removed_files = Get-ChildItem -Path $video.DirectoryName -Filter $newSet
    foreach ($file in $removed_files) {
        $deleted_file = $video.DirectoryName + "\\" + $file
        $extn = [IO.Path]::GetExtension($deleted_file)
        if ($extn -ne ".mkv") {
            Remove-Item $deleted_file
        }
    }
    Write-Host "done deleting files"
}