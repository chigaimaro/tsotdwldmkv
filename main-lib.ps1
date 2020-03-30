# generic functions
. ("$PSScriptRoot\ccextract.ps1")
. ("$PSScriptRoot\tuneskit.ps1")
. ("$PSScriptRoot\allavsoft.ps1")

function Set-SubtitleType {
    param (
        $inputFile
    )
        
    # iTunes movies - Folder with the same name (subs extracted with Tuneskit)
    if (Test-TuneskitSubs $inputFile){
        return "tnskit"
    }
    # iTunes TV - Same File name - SRT extension (subs extracted with CCextractor)
    elseif (Test-CCextractSubs $inputFile) {
        return "ccex"
    }
    # Crunchyroll - Same file name - additional enUS (subs extracted with Allavsoft)
    elseif (Test-AllavCRSubs $inputFile) {
        return "allav"
    } else {
        return "unknwn"
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
    if ($subTitleType -eq "tnskit") {
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
        if ($LASTEXITCODE -eq 0) {
            Write-Log "Completed File: $($mkvArgList[2])" | Out-Null
            if (($subTitleType -eq "allav")) {
                Set-JapaneseTrack $mkvArgList[1]
                Write-Log "Set audio track to Japanese: $($mkvArgList[1])" | Out-Null
            }
            $Global:delete_files = $true
        } else {
            Write-Log "Conversion failed: $($mkvArgList[2])" | Out-Null
            $Global:delete_files = $false
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


function Get-Logfile {

    function Build-LogFile { 
        $current_file = "log-" + (Get-Date -format yyyyMMddHHmmssff) + ".txt"
        $log_path = $PSScriptRoot + "\logs"
        New-Item -Path $log_path -ItemType "directory" -Force 
        $current_file | Out-File -FilePath "$PSScriptRoot\logs\$current_file"
        return "$log_path\$current_file".ToString()
    }
    
    $current_log = Build-LogFile
    $current_log[1]
}

function Write-Log {
    param (
        $message
    )
    function Get-TimeStamp {
        return "[{0:yyyy/MM/dd} {0:HH:mm:ss}]" -f (Get-Date)   
    }
    Write-Output "$(Get-TimeStamp) $message" | Out-file $logfile -append

}