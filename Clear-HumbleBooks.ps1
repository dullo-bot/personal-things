function Clear-HumbleBooks {
    param (
        [string]
        $PathToBooks = "C:\Users\Thilo\Documents\Bücher\HumbleBundle\"
    )
    $duplicateObjects = Get-ChildItem -Path $PathToBooks -Recurse | Get-FileHash | Group-Object -Property Hash | Where-Object Count -GT 1 | foreach {$_.Group | select Path, Hash}
    $diff = $duplicateObjects | select -Property Hash -Unique 
    $diff2 = $duplicateObjects | Sort-Object -Property Hash -Unique
    #Remove-Item -Path $duplicateObjects.Path
}