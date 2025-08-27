# List of target machines
$computers = @("Machine1", "Machine2", "Machine3")

# Define the list of folders to exclude
$foldersToExclude = @(
    "E:\ArcGIS",
    "E:\arcgisportal",
    "E:\arcgisserver",
    "E:\arcgisdatastore",
    "E:\Automation"
)

# Script block to execute on each machine
$scriptBlock = {
    param($foldersToExclude)
    $serverName = $env:COMPUTERNAME
    Write-Host "Starting to exclude folders from Windows Defender on $serverName"
    foreach ($folder in $foldersToExclude) {
        Add-MpPreference -ExclusionPath $folder
        Write-Host "Excluded $folder on $serverName"
    }
    Write-Host "Completed excluding folders from Windows Defender on $serverName"
}

# Execute the script block on each target machine
foreach ($computer in $computers) {
    Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock -ArgumentList $foldersToExclude
}