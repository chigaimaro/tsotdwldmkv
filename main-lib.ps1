# generic functions
. (".\ccextract.ps1")
. (".\tuneskit.ps1")
. (".\allavsoft.ps1")
function Set-SubtitleType {
    param (
        $inputFile
    )
        
    # iTunes movies - Folder with the same name (subs extracted with Tuneskit)
    if (Test-TuneskitSubs $inputFile){
        return "tksubs"
    }
    # iTunes TV - Same File name - SRT extension (subs extracted with CCextractor)
    elseif (Test-CCextractSubs $inputFile) {
        return "ccex"
    }
    # Crunchyroll - Same file name - additional enUS (subs extracted with Allavsoft)
    elseif (Test-AllavCRSubs $inputFile) {
        return "allav"
    }
}

function Read-TargetDirectory {
    param(
        $videosPath
    )
    $videoExtensions = @("*.mp4","*.m4v")
    $queue = Get-ChildItem -Path $videosPath -Include $videoExtensions -Recurse
    return (, $queue)
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

function Get-MKVFullArgs {
    param (
        $inputFile,
        $subTitleType
    )
    $current_mkv = $(Join-Path $inputFile.DirectoryName  $inputFile.BaseName) + ".mkv"
    $mkvArgList = @('-o', $current_mkv, $inputFile.FullName)
    if ($subTitleType -eq "tnksit") {
        $mkvArgList += Get-TNSKArgs $inputFile
    } elseif ($subTitleType -eq "ccex") {
        $mkvArgList += Get-CCeArgs $inputFile
    } elseif ($subTitleType -eq "allav") {
        $mkvArgList += Get-AllavCRArgs $inputfile
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
    # $processed_files = Start-Process -FilePath $mkvProgPath -ArgumentList $mkvArgList -Wait -PassThru
    
    if ($LASTEXITCODE -ne '0') {
        Write-Output "Conversion failed"
        exit(1)
    }

    if ($subTitleType -eq "allav") {
        Set-JapaneseTrack $mkvArgList[1]
    }
}

function Invoke-SessionCleanup {
    param (
        $inputVideo,
        $subTitleType
    )

    switch ($subTitleType) {
        "allav" { Remove-AllavCRItems $inputVideo; Break }
        "tnskit" { Remove-TNSKItems $inputVideo; Break }
        "ccex" { Remove-CCeItems $inputVideo; Break } 
        Default {}
    }
}