function Clear-HumbleBooks {
    <#
    .SYNOPSIS
    just another test
    .DESCRIPTION
    this function should remove all my duplicate Humble Books from different Bundles
    .EXAMPLE
    Clear-Humblebooks
    .PARAMETER PathToBooks
    The Path where the duplicate files are located
    .NOTES
    nothing important yes
    #>
    
    param (
        [string]
        $PathToBooks = "C:\Users\Thilo\Documents\Bücher\HumbleBundle\"
    )
    $duplicateObjects = Get-ChildItem -Path $PathToBooks -Recurse | Get-FileHash | Group-Object -Property Hash | Where-Object Count -GT 1 | ForEach-Object {$_.Group | Select-Object Path, Hash}
    $diff = $duplicateObjects | Select-Object -Property Hash -Unique 
    $diff2 = $duplicateObjects | Sort-Object -Property Hash -Unique
    #Remove-Item -Path $duplicateObjects.Path
}