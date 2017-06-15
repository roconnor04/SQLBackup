$path = "C:\Backups\Test\"

Get-SqlDatabase -ServerInstance localhost |
Where { $_.Name -ne 'tempdb' } | foreach{
Backup-SqlDatabase -DatabaseObject $_ -BackupFile "C:\Backups\Test\$($_.NAME)_db_$(Get-Date -UFormat %Y%m%d%H%M).bak"}

function create-7zip([String] $aDirectory, [String] $aZipfile){
    [string]$pathToZipExe = "C:\Program Files\7-zip\7z.exe";
    [Array]$arguments = "a", "-t7z", "$aZipfile", "$aDirectory";
    & $pathToZipExe $arguments;
}

create-7zip "C:\Backups\Test\*"  "C:\Backups\Test\test.7z"


get-childitem $path -include *.bak -recurse | foreach ($_) {remove-item $_.fullname}