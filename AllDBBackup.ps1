$path = "C:\Backups\Location\"
$Username = "ExampleUser"
$Password = ConvertTo-SecureString "ExamplePassword" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential($Username, $Password)

Get-SqlDatabase -ServerInstance localhost |
Where { $_.Name -ne 'tempdb' } | foreach{
Backup-SqlDatabase -DatabaseObject $_ -BackupFile "C:\Backups\Location\$($_.NAME)_db_$(Get-Date -UFormat %Y%m%d%H%M).bak"}

function create-7zip([String] $aDirectory, [String] $aZipfile){
    [string]$pathToZipExe = "C:\Program Files\7-zip\7z.exe";
    [Array]$arguments = "a", "-t7z", "$aZipfile", "$aDirectory";
    & $pathToZipExe $arguments;
}

create-7zip "C:\Backups\Location\*"  "C:\Backups\Location\Web_$(Get-Date -UFormat %Y%m%d%H%M).7z"


get-childitem $path -include *.bak -recurse | foreach ($_) {remove-item $_.fullname}

New-PSDrive –Name “K” –PSProvider FileSystem –Root “\\Final\Destination\DBs” –Credential $mycreds
Move-Item -path "$path*.7z" -Destination K:
Remove-PSDrive K
