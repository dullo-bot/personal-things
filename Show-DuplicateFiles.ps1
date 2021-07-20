function Show-DuplicateFiles {
    <#
    .SYNOPSIS
    deletes duplicate files
    .DESCRIPTION
    this function removes all duplicate files.
    It compares by the hashes and deletes the files found in the second folder
    .EXAMPLE
    Remove-DuplicateFiles -Path "C:/this/is/a/path"
    .PARAMETER Path
    The Path where duplicate files are located
    .NOTES
    Created by: dullo-bot
    Date: 20210628
    Tested with: Win10, PS 5.0
    #>
    
    param (
        [Parameter(Mandatory)]
        [string]
        $Path = "C:\Users\Thilo\Documents\Bücher\HumbleBundle\"
        
    )
    Get-ChildItem -Path $Path -Recurse | Get-FileHash | Group-Object -Property Hash | Where-Object Count -GT 1 | ForEach-Object{$_.Group | Select-Object Path, Hash}
}