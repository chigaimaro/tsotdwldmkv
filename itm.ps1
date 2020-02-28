function Test-iTunesMovieSubs {
    param (
        $inputFile
    )
    # iTunes movies - Folder with the same name (subs extracted with Tuneskit)
    $itmDIR = $(Join-Path $inputFile.DirectoryName $inputFile.BaseName)
    if ( $(Try { Test-Path -Path $itmDIR.trim() -PathType Container} Catch { $false }) ) {
        return $true
      }
     Else {
        return $false
      }
}

function Get-GetITMArgs {
    param (
        $inputFile
    )
    # Creates an array of valid subtitles
    $subtitleDir = $(Join-Path $inputFile.DirectoryName $inputFile.BaseName)
    $subtitleExtension = @("*.srt")
    $queue = @()
    $foundSubtitles = Get-ChildItem -Path $subtitleDir -Include $subtitleExtension -Recurse

    foreach ($subtitle in $foundSubtitles) {
        if (Test-Subtitle $subtitle) {
            $queue += Get-Language $subtitle
        }
    }
    return $queue
}

function Test-Subtitle {
    param (
            $incomingSubtitle
        ) 
    $subtitleTest =  Get-content $incomingSubtitle | Measure-Object -Line -Character -Word -IgnoreWhiteSpace
    if ($subtitleTest.Lines -le 3 -AND $subtitleTest.Characters -le 28 -AND $subtitleTest.Words -le 4) {
        return $false
    } elseif ($subtitleTest.Lines -le 3 -AND $subtitleTest.Characters -le 28 ) {
        return $false
    }     
    else {return $true}
}

function Get-Language($incomingSubtitle) {
    # parse file name and return mkv processing string
    # Regex string _[^_]+[^.srt]
    $fullstring = @()
    $pulledFileSize = (Get-Item $incomingSubtitle).length/1KB
    switch ($incomingSubtitle) {
        {$_ -like "*(Hant)*"} {$fullstring += ("--language", "0:chi", '--track-name', '0:"[Chinese (simplified)] Unstyled"'); break }
	    {$_ -like "*Arabic*"} {$fullstring += ("--language", "0:ara", '--track-name', '0:"[Arabic] Unstyled"'); break }
        {$_ -like "*Chinese(Hans)*"} {$fullstring += ("--language", "0:chi", '--track-name', '0:"[Chinese(traditional)] Unstyled"'); break }
        {$_ -like "*Chinese(Hant)*"} {$fullstring += ("--language", "0:chi", '--track-name', '0:"[Chinese (simplified)] Unstyled"'); break }
        {$_ -like "*Croatian*"} {$fullstring += ("--language", "0:hrv", '--track-name', '0:"[Croatian] Unstyled"'); break }
        {$_ -like "*Czech*"} {$fullstring += ("--language", "0:cze", '--track-name', '0:"[Czech] Unstyled"'); break }
        {$_ -like "*Danish*"} {$fullstring += ("--language", "0:dan", '--track-name', '0:"[Danish] Unstyled"'); break }
        {$_ -like "*Dutch*"} {$fullstring += ("--language", "0:dut", '--track-name', '0:"[Dutch] Unstyled"'); break }
        {$_ -like "*English(GB)*"} {$fullstring += ("--language", "0:eng", '--track-name', '0:"[British English] Unstyled"'); break }
        {$_ -like "*English(US)*"} {$fullstring += ("--language", "0:eng", '--track-name', '0:"[US English] Unstyled"'); break }
        {$_ -like "*English(US) CC*"} {$fullstring += ("--language", "0:eng", '--track-name', '0:"[US Closed Captions] Unstyled"'); break }
        {$_ -like "*English CC*"} {$fullstring += ("--language", "0:eng", '--track-name', '0:"[US Closed Captions] Unstyled"'); break }
        {$_ -like "*Finnish*"} {$fullstring += ("--language", "0:fin", '--track-name', '0:"[Finnish] Unstyled"'); break }
        {$_ -like "*French*"} {$fullstring += ("--language", "0:fra", '--track-name', '0:"[French] Unstyled"'); break }
        {$_ -like "*German(DE)*"} {$fullstring += ("--language", "0:deu", '--track-name', '0:"[Deutsch] Unstyled"'); break }
        {$_ -like "*German*"} {$fullstring += ("--language", "0:deu", '--track-name', '0:"[Deutsch] Unstyled"'); break }
        {$_ -like "*Greek, Modern*"} {$fullstring += ("--language", "0:gre", '--track-name', '0:"[Greek (Modern)] Unstyled"'); break }
        {$_ -like "*Hebrew(IL)*"} {$fullstring += ("--language", "0:heb", '--track-name', '0:"[Hebrew] Unstyled"'); break }
        {$_ -like "*Hebrew*"} {$fullstring += ("--language", "0:heb", '--track-name', '0:"[Hebrew] Unstyled"'); break }
        {$_ -like "*Hindi*"} {$fullstring += ("--language", "0:hin", '--track-name', '0:"[Hindi] Unstyled"'); break }
        {$_ -like "*Hungarian*"} {$fullstring += ("--language", "0:hun", '--track-name', '0:"[Hungarian] Unstyled"'); break }
        {$_ -like "*Icelandic*"} {$fullstring += ("--language", "0:ice", '--track-name', '0:"[Icelandic] Unstyled"'); break }
        {$_ -like "*Indonesian*"} {$fullstring += ("--language", "0:ind", '--track-name', '0:"[Indonesian] Unstyled"'); break }
        {$_ -like "*Italian(IT)*"} {$fullstring += ("--language", "0:ita", '--track-name', '0:"[Italian] Unstyled"'); break }
        {$_ -like "*Italian*"} {$fullstring += ("--language", "0:ita", '--track-name', '0:"[Italian] Unstyled"'); break }
        {$_ -like "*Korean*"} {$fullstring += ("--language", "0:kor", '--track-name', '0:"[Korean] Unstyled"'); break }
        {$_ -like "*Malay*"} {$fullstring += ("--language", "0:may", '--track-name', '0:"[Malay] Unstyled"'); break }
        {$_ -like "*Norwegian*"} {$fullstring += ("--language", "0:nor", '--track-name', '0:"[Norwegian] Unstyled"'); break }
        {$_ -like "*Polish*"} {$fullstring += ("--language", "0:pol", '--track-name', '0:"[Polish] Unstyled"'); break }
        {$_ -like "*Portuguese(BR)*"} {$fullstring += ("--language", "0:por", '--track-name', '0:"[Portuguese(BR)] Unstyled"'); break }
        {$_ -like "*Portuguese(PT)*"} {$fullstring += ("--language", "0:por", '--track-name', '0:"[Portuguese(PT)] Unstyled"'); break }
        {$_ -like "*Russian*"} {$fullstring += ("--language", "0:rus", '--track-name', '0:"[Russian] Unstyled"'); break }
        {$_ -like "*Slovenian*"} {$fullstring += ("--language", "0:slv", '--track-name', '0:"[Slovenian] Unstyled"'); break }
        {$_ -like "*Spanish(419)*"} {$fullstring += ("--language", "0:spa", '--track-name', '0:"[Español] Unstyled"'); break }
        {$_ -like "*Spanish(ES)*"} {$fullstring += ("--language", "0:spa", '--track-name', '0:"[Español(Spain)] Unstyled"'); break }
        {$_ -like "*Swedish*"} {$fullstring += ("--language", "0:swe", '--track-name', '0:"[Swedish] Unstyled"'); break }
        {$_ -like "*Thai(TH)*"} {$fullstring += ("--language", "0:tha", '--track-name', '0:"[Thai] Unstyled"'); break }
        {$_ -like "*Thai*"} {$fullstring += ("--language", "0:tha", '--track-name', '0:"[Thai] Unstyled"'); break }
        {$_ -like "*Turkish*"} {$fullstring += ("--language", "0:tur", '--track-name', '0:"[Turkish] Unstyled"'); break }
        {$_ -like "*Ukrainian*"} {$fullstring += ("--language", "0:ukr", '--track-name', '0:"[Ukrainian] Unstyled"'); break }
        {$_ -like "*Vietnamese*"} {$fullstring += ("--language", "0:vie", '--track-name', '0:"[Vietnamese] Unstyled"'); break }
    }
    $fullstring += ("--default-track", "0:no")
    if ($pulledFileSize -le 5 -AND $pulledFileSize -gt 0.04) {
        $fullstring += ("--forced-track", "0:yes")
    }
    $fullstring += $incomingSubtitle
    return $fullstring
}

function Remove-ITMStuff {
    Param(
        $inputFile, 
        $subtitleDirectory)
    $subtitleDirectory = $(Join-Path $inputFile.DirectoryName $inputFile.BaseName)
    Remove-Item -LiteralPath $subtitleDirectory -Force -Recurse
    Remove-Item $inputFile -Force
}