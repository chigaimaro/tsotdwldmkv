## TSOT - dwnld2MKV
A very niche command-line tool.
Tool is provided AS-IS and comes with no support.  

### Installation - download all files into one folder
### Usage - dwnld2mkv.ps1 "path-to-videos"

[Allavsoft](https://www.allavsoft.com/) For video files from Crunchyroll ***ONLY*** (no other website is supported).  To bind the files into a MKV:

 - Go Option -> Preference -> General Tab: Click "Restore to Default" button to set the File Name back to `%(title).%(ext)`
 ---
[CCextractor](https://www.ccextractor.org/) - must have the following settings:

 - In Output (1) tab - Radio button checked -> "Use the same name as the input file...."
 - On Input options tab - Split Type section -> "These are individual, unrelated files.
 - Leave the extension as SRT
 - on Output (2) Tab - Text position section: Radio button selected -> "Export text in its original position. ...."
---
[TunesKit Subtitle Extractor](https://www.tuneskit.com/freeware.html) - must have the following settings:
 - Output folder must be in the same directory as your MP4 files extracted from iTunes.