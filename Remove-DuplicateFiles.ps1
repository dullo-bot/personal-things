function Remove-DuplicateFiles {
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
  .Parameter Recurse
  Decides, if you want to search in the provided Path or in its subfolders
  .Parameter delete
  Decide, if you want to delete the duplicate file/files
  .NOTES
  Created by: dullo-bot
  Date: 20210907
  Tested with: Win10, PS 5.1
  #>
  
  param (
      [string]
      $Path = "C:\Users\bs000q18u\Documents\",
      [switch]
      $Recurse,
      [switch]
      $delete 
  )
  if ($Recurse) {
    $duplicateObjects = Get-ChildItem -Path $Path -Recurse| Get-FileHash | Group-Object -Property Hash | Where-Object Count -GT 1 | ForEach-Object{$_.Group | Select-Object Path, Hash}
  }
  else {
      $duplicateObjects = Get-ChildItem -Path $Path | Get-FileHash | Group-Object -Property Hash | Where-Object Count -GT 1 | ForEach-Object{$_.Group | Select-Object Path, Hash}
  }
  $duplicateObjects
  if ($delete) {
    for ($i = 0; $i -lt $duplicateObjects.Count; $i++) {
      if ($i % 2) {
          Remove-Item -Path $duplicateObjects[$i].Path
      }
    }
  }
}
